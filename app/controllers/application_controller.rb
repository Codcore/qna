class ApplicationController < ActionController::Base
  before_action :gon_user

  def gon_user
    gon.user_id = current_user.id if user_signed_in?
  end
end
