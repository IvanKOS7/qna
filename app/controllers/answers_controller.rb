class AnswersController < ApplicationController
  before_action :load_question, only: %i[create]
  before_action :find_answer, only: [:update, :destroy]
  before_action :load_answer, only: [:best]


  def create
    @answer = @question.answers.create(answer_params)
    @answer.author = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
    @question = @answer.question
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
  end

  def best
    if @answer.mark_as_best
      redirect_to @answer.question, notice: 'New best answer!'
    end
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def load_answer
    @answer = Answer.find(params[:answer_id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [])
  end
end
