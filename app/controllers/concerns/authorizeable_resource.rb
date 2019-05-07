require 'active_support/concern'

module AuthorizeableResource
  include ActiveSupport::Concern

  def authorize_author_for!(resource)
    render template: 'errors/403_error', status: :forbidden unless current_user.authorized_for?(resource)
  end
end
