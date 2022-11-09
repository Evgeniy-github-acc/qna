class AnswerShowSerializer < AnswerSerializer
  include Rails.application.routes.url_helpers
  
  belongs_to :author
  belongs_to :question
  has_many :comments
  has_many :attachments
  has_many :links

  def attachments
    object.files.map { |attachment| url_for(attachment) }
  end
end


