# frozen_string_literal: true

module Api
  module V1
    class AnswersController < Api::V1::BaseController
      before_action :find_question, only: [:create]
      before_action :find_answer, only: %i[update destroy]

      def show
        @answer = Answer.find(params[:id])
        render json: @answer
      end

      def create
        authorize! :create, @answer
        @answer = @question.answers.new(body: params[:body], user_id: current_resource_owner)
        if @answer.save
          render json: @answer
        else
          errors_handler(@answer)
        end
      end

      def update
        authorize! :create, @answer
        @answer.update(body: params[:body])
        if @answer.save
          render json: @answer
        else
          errors_handler(@answer)
        end
      end

      def destroy
        authorize! :create, @answer
        head :ok if @answer.destroy
      end

      private

      def find_question
        @question = Question.with_attached_files.find(params[:id])
      end

      def find_answer
        @answer = Answer.find(params[:id])
      end
    end
  end
end
