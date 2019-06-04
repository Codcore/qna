class ApplicationController < ActionController::Base
  respond_to :html, :json, :js

  before_action :gon_user

  def gon_user
    gon.user_id = current_user.id if user_signed_in?
  end

  rescue_from CanCan::AccessDenied, with: :authorization_error

  def authorization_error(exception)
    message = "You're not authorized for this request"
    respond_with do |format|
      format.html { redirect_to root_url, alert: message }
      format.json { render json: { status: "error", message: message, code: 403 }, status: :forbidden }
      format.js do
        flash[:alert] = message
        render 'errors/403_error'
      end
    end
  end
end
