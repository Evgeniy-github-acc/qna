class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :find_question, only: %i[show update destroy]

  authorize_resource class: Question

  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
    render json: @question, serializer: QuestionSerializer
  end

  def create
    @question = current_resource_owner.questions.new(question_params)

    if @question.save
      render json: @question, serializer: QuestionSerializer
    else
      render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @question.destroy
  end
  

  def update
    if @question.update(question_params)
      render json: @question, serializer: QuestionSerializer
    else
      render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
