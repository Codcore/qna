class SubscriptionsController < ApplicationController

  before_action :authenticate_user!

  expose :question
  expose :subscription, -> { question.subscriptions.find_by(user_id: current_user.id) }

  def create
    question.subscribers.push(current_user)
    redirect_to question
  end

  def destroy
    authorize! :destroy, subscription
    question.subscriptions.delete(subscription)
    redirect_to question
  end
end