class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true, touch: true
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'

  validates :body, presence: true

  after_create_commit :publish_comment

  ThinkingSphinx::Callbacks.append(self, :behaviours => [:real_time])

  private
  
  def publish_comment
    ActionCable.server.broadcast(
      "questions/#{question_id}/comments",
      to_json(include: :author)
    )
  end

  def question_id
    case commentable_type 
    when 'Question'
      commentable_id
    when 'Answer'
      Answer.find(commentable_id).question_id
    end
  end
end
