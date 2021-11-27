class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:new, :create]

 def update
   @answer = Answer.find(params[:id])
   @answer.update(answer_params)
   @question = @answer.question
  end

  def create
    @answer = @question.answers.create((answer_params).merge(author: current_user))
  end

  def destroy
    @answer = Answer.find(params[:id])
    @question = @answer.question
    @answer.destroy if current_user.author_of?(@answer)
    @answer_id = @answer.id
  end

  private

  def load_question
    @question = Question.find(params[:question_id])    
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end
end
