# frozen_string_literal: true

class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy]
  before_action :find_question, only: %i[subscribe unsubscribe]
  after_action :publish_question, only: [:create]

  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @best_answer = @question.best_answer
    @answer.links.build
    @other_answers = @question.answers.where.not(id: @question.best_answer_id)
  end

  def new
    @question = Question.new(author: current_user)
    @question&.links&.build
    @question.reward = Reward.new
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    @question.update(question_params)
    if @question.save
      redirect_to @question
    else
      render :edit
    end
  end

  def best
    @question.mark_as_best(answer)
  end

  def destroy
    @question.destroy if current_user.author_of?(@question)
    redirect_to questions_path
  end

  def subscribe
    @question.subscription.users.append(current_user)
    redirect_to @question, notice: 'Your subscription is running'
  end

  def unsubscribe
    @question.subscription.users.delete(current_user)
    redirect_to @question, notice: 'Your subscription is canceled'
  end

  private

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/short_question',
        locals: { q: @question }
      )
    )
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: %i[name url])
  end
end
