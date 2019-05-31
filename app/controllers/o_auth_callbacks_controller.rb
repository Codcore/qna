class OAuthCallbacksController < Devise::OmniauthCallbacksController

  before_action :check_email, only: [:twitter]

  def github
    authorize_with('Github')
  end

  def twitter
    authorize_with('Twitter')
  end

  def google_oauth2
    authorize_with('Google')
  end

  private

  def authorize_with(provider)
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user&.persisted?
      sign_in_and_redirect @user, events: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  def check_email
    unless OmniAuth::AuthHash.new(request.env['omniauth.auth']).info[:email]
      render 'shared/email_form'
    end
  end
end