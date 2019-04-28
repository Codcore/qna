require 'active_support/concern'

module AuthorizeableResource
  extend ActiveSupport::Concern

  def authorized?(user)
    user == author
  end
end
