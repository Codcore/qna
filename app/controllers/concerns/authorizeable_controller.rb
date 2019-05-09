require 'active_support/concern'

module AuthorizeableController
  extend ActiveSupport::Concern

  def authorize_author_for!(resource)
    return render template: 'errors/403_error', status: :forbidden unless current_user.authorized_for?(resource)
  end
end
