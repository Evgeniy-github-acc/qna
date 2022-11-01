class Answer < ApplicationRecord
  include Linkable
  include Votable
  include Commentable

  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  belongs_to :question
  has_many_attached :files
  
  validates :body, presence: true

  scope :not_best_answers, -> (question){ where.not(id: question.best_answer_id) }

  after_create_commit :publish_answer

  def mark_as_best
		question.update(best_answer_id: self.id)
	end

  def best?
    question.best_answer_id == self.id
  end

  def publish_answer
    ActionCable.server.broadcast(
      "questions/#{question.id}/answers", 
      to_json(include: [
        :author,
        :files,
        :links],
        methods: :rating
      )
    )
  end
end
