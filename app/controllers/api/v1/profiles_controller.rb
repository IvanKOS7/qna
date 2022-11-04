# frozen_string_literal: true

module Api
  module V1
    class ProfilesController < Api::V1::BaseController
      def me
        render json: current_user
      end

      def index
        # authorize! :index, current_resource_owner
        render json: User.excluding(current_user)
      end
    end
  end
end
