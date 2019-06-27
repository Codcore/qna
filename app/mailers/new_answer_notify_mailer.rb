class NewAnswerNotifyMailer < ApplicationMailer

  def notify_email(answer, user)
    @answer   = answer
    @question = Question.find(@answer.question_id)
    @author   = user

    mail to: user.email
  end
end
