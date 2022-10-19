class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :find_question, only: [:update, :destroy]


  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    @question = Question.find(params[:id])
    render json: @question
  end

  def create
    question = Question.new(title: params[:title], body: params[:body])
    if question.save
      render json: question
    else
      render json: question.errors.full_messages
    end
  end

  def update
    @question.update(title: params[:title], body: params[:body])
    if @question.save
      render json: @question
    else
      render json: @question.errors.full_messages
    end
  end

  def destroy
    if @question.destroy
      head :ok
    end
  end


  private

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end
end
