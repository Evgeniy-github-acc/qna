class AnswerChannel < ApplicationCable::Channel
  def subscribed
    stream_from "question/#{params[:question_id]}/answers"
  end

  def follow
    stop_all_streams
    stream_from "questions/#{params[:question_id]}/answers"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
