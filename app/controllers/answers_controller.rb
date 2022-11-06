class AnswersController < ApplicationController
  include Voted
  
  before_action :authenticate_user!
  before_action :load_question, only: [:new, :create]
  before_action :load_answer, only: [:update, :destroy]

  authorize_resource

 def update
   @answer.update(answer_params)
   @question = @answer.question
  end

  def create
    @answer = @question.answers.create((answer_params).merge(author: current_user))
  end

  def destroy
    @question = @answer.question
    @answer.destroy
    @answer_id = @answer.id
    flash[:notice] = 'Answer successfully deleted.'
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])    
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end
end
