class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show destroy update]

  authorize_resource

  after_action :publish_question, only: :create

  rescue_from ActiveRecord::RecordNotFound, with: :rescue_with_question_not_found

  def index
    @questions = Question.all
  end

  def show
    @answer = user_signed_in? ? current_user.answers.new() : Answer.new
    @best_answer = @question.best_answer
    @other_answers = @question.answers.not_best_answers(@question)
    @answer.links.new
    gon.question_id = @question.id
  end

  def new
    @question = Question.new
    @question.links.build
  end

  def create
    @question = Question.new((question_params).merge(author: current_user))

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new  
    end
  end

  def update
    @question.update(question_params) if current_user.author_of?(@question)
    
    if !question_params[:best_answer_id].nil? && !@question.award.nil?
      @question.award.update(user: @question.best_answer.author)
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
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, 
                                     :body, 
                                     :best_answer_id,  
                                     files: [], 
                                     links_attributes: [:name, :url, :_destroy],
                                     award_attributes: [:id, :title, :image, :_destroy])
  end

  def rescue_with_question_not_found
    render html: '<p>Qeustion not found</p>'.html_safe
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'question_channel',
      ApplicationController.render(
        partial: 'questions/question',
        locals: { question: @question }
      )
    )
  end
end
