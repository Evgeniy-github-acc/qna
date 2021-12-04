class Answer < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  belongs_to :question
  has_many_attached :files
  has_many :links, dependent: :destroy, as: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank
  
  validates :body, presence: true

  scope :not_best_answers, -> (question){ where.not(id: question.best_answer_id) }

  def mark_as_best
		question.update(best_answer_id: self.id)
	end

  def best?
    question.best_answer_id == self.id
  end
end
