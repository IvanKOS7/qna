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
    authorize! :create, @question
    question = Question.new(title: params[:title], body: params[:body])
    if question.save
      render json: @current_resource_owner
    else
      render json: @current_resource_owner
    end
  end

  def update
    authorize! :create, @question
    @question.update(title: params[:title], body: params[:body])
    if @question.save
      render json: @question
    else
      errors_handler(@question)
    end
  end

  def destroy
    authorize! :create, @question
    if @question.destroy
      render json: :success
    end
  end


  private

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end
end
