class Api::V1::ProfilesController < Api::V1::BaseController

  def index
    @users = User.where.not(email: current_resource_owner.email)
    render json: @users
  end

  def me
    render json: current_resource_owner
  end
end