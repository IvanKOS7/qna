class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_question, only: [:create]
  before_action :find_answer, only: [:update, :destroy]

  def show
    @answer = Answer.find(params[:id])
    render json: @answer
  end

  def create
    @answer = @question.answers.new(body: params[:body])
    if @answer.save
      render json: @answer
    else
      render json: @answer.errors.full_messages
    end
  end

  def update
    @answer.update(body: params[:body])
    if @answer.save
      render json: @answer
    else
      render json: @answer.errors.full_messages
    end
  end

  def destroy
    if @answer.destroy
      head :ok
    end
  end

  private

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end
end