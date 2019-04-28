require 'active_support/concern'

module AuthorizeableController
  extend ActiveSupport::Concern

  def authorize_author_for!(resource)
    return render template: 'errors/401_error', status: :unauthorized unless resource.authorized?(current_user)
  end
end
