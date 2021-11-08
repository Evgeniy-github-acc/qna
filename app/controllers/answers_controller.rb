class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :define_question, only: [:new, :create, :destroy]

 
  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new((answer_params).merge(author: current_user))

    if @answer.save
      redirect_to question_path(@question)
    else
      render 'questions/show' 
    end
    
  end

  def destroy
    @answer = Answer.find(params[:id])
    if current_user.author_of?(@answer)
      @answer.destroy
      redirect_to question_path(@question), notice: 'Your answer was deleted'
    else
      redirect_to question_path(@question), notice: 'You can delete only your own answers'
    end 
  end

  private

  def define_question
    @question = Question.find(params[:question_id])    
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
