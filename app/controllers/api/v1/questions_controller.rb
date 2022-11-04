# frozen_string_literal: true

module Api
  module V1
    class QuestionsController < Api::V1::BaseController
      before_action :find_question, only: %i[update destroy]

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
        end
        render json: @current_resource_owner
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
        render json: :success if @question.destroy
      end

      private

      def find_question
        @question = Question.with_attached_files.find(params[:id])
      end
    end
  end
end
