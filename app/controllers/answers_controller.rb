class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:new, :create]

 
 # def new
  #  @answer = @question.answers.new
 # end

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
    if current_user.author_of?(@answer)
      @answer.destroy
      redirect_to question_path(@answer.question_id), notice: 'Your answer was deleted'
    else
      redirect_to question_path(@answer.question_id), notice: 'You can delete only your own answers'
    end 
  end

  private

  def load_question
    @question = Question.find(params[:question_id])    
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
