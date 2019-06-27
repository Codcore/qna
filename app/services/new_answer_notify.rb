class Services::NewAnswerNotify
  def send_notify(answer, user)
    NewAnswerNotifyMailer.notify_email(answer, user).deliver_later
  end
end