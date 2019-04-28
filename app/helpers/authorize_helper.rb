module AuthorizeHelper
  def authorize_author_for!(resource)
    return render template: 'errors/401_error', status: :unauthorized unless authorized_user_for_resource?(resource)
  end

  def authorized_user_for_resource?(resource)
    current_user == resource.author
  end
end