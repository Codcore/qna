class NewAnswerNotifyMailer < ApplicationMailer

  def notify_email(answer)
    @answer   = answer
    @question = Question.find(@answer.question_id)
    @author   = User.find(@question.author_id)

    mail to: answer.question.author.email
  end
end
