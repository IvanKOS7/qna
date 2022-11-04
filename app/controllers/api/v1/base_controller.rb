# frozen_string_literal: true

module Api
  module V1
    class BaseController < ApplicationController
      rescue_from CanCan::AccessDenied do |exception|
        render json: exception.message, status: :unprocessable_entity
      end

      private

      def current_resource_owner
        @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
      end

      def errors_handler(resource)
        render json: resource.errors.full_messages
      end
    end
  end
end
