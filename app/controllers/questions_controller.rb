class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new((question_params).merge(author: current_user))

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new  
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      redirect_to questions_path,  notice: 'Your question successfully deleted.'
    else
      redirect_to questions_path,  notice: 'You can delete only yor own questions'
    end  
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
