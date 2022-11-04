# frozen_string_literal: true

class AnswersController < ApplicationController
  include Voted

  before_action :load_question, only: %i[create]
  before_action :find_answer, only: %i[update destroy]
  before_action :load_answer, only: [:best]
  after_action :publish_answer, only: [:create]

  authorize_resource

  def create
    @answer = @question.answers.create(answer_params)
    @answer.author = current_user

    respond_to do |format|
      if @answer.save
        NotificationJob.perform_later(@answer)
        format.json { render json: @answer }
      else
        format.json { render json: @answer.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
    @question = @answer.question
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
  end

  def best
    redirect_to @answer.question, notice: 'New best answer!' if @answer.mark_as_best
  end

  private

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      "answers_for_q_#{@answer.question.id}",
      { body: ApplicationController.render(partial: 'answers/answer', locals: { answer: @answer, current_user: current_user }),
        question_id: @answer.question_id }
    )
  end

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
    params.require(:answer).permit(:body, files: [], links_attributes: %i[name url])
  end
end
