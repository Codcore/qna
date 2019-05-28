class CommentariesChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "commentaries_for_question_#{data['question_id']}"
  end
end