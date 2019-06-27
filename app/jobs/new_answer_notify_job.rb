class NewAnswerNotifyJob < ApplicationJob
  queue_as :default

  def perform(answer, user)
    Services::NewAnswerNotify.new.send_notify(answer, user)
  end
end
