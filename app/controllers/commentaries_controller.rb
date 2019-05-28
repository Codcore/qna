class CommentariesController < ApplicationController

  expose :question, id: ->{ params[:question_id] }
  expose :answer, id: ->{ params[:answer_id]}

  before_action :authenticate_user!
  before_action :find_commentary, only: [:update, :destroy]
  before_action :find_commentable, only: [:create]

  after_action :publish_commentary, only: [:create]

  def create
    @commentary = @commentable.commentaries.new(commentary_params)
    @commentary.user_id = current_user.id
    @commentary.save
  end

  def destroy
    @commentary.destroy  if current_user.authorized_for?(@commentary)
  end

  private

  def find_commentary
    @commentary = Commentary.find(params[:id])
  end

  def find_commentable
    @commentable = question if params[:question_id].present?
    @commentable = answer if params[:answer_id].present?
  end

  def commentary_params
    params.require(:commentary).permit(:body)
  end

  def publish_commentary
    return if @commentary.errors.any?
    question_id = @commentable.is_a?(Question) ? @commentable.id : @commentable.question.id
    ActionCable.server.broadcast("commentaries_for_question_#{question_id}", commentary: @commentary)
  end
end
