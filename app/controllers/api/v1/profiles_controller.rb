class Api::V1::ProfilesController < Api::V1::BaseController
  
  def me
    render json: current_user
  end

  def index
    # authorize! :index, current_resource_owner
    render json: User.excluding(current_user)
  end
end
