class AnswersController < ApplicationController
  before_action :load_question, only: [:index, :show, :create, :new]
  before_action :find_answer, only: [:show, :edit, :update, :destroy]

  def index
    @answers = @question.answers
  end

  def show; end

  def new
    @answer = @question.answers.new
    @answer.author = current_user
  end

  def edit; end

  def create
    @answer = @question.answers.new(answer_params)
    current_user.answers.push(@answer)
    if @answer.save
      redirect_to @question
    else
      render :new
    end
  end

  def update
    @answer.update(answer_params)
    if @answer.save
      redirect_to @answer.question
    else
      render :edit
    end
  end

  def destroy
    if @answer.author.id == current_user.id
      @answer.destroy
      render :index
    end
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:question_id, :body)
  end
end
