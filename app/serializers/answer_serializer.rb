class AnswerSerializer < AnswersSerializer
  include Rails.application.routes.url_helpers
  
  has_many :comments
  has_many :attachments
  has_many :links

  def attachments
    object.files.map { |attachment| url_for(attachment) }
  end
end
