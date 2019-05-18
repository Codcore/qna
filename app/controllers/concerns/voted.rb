module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:up_vote, :down_vote]
    before_action :authenticate_user!, only: [:up_vote, :down_vote]
  end

  def up_vote
    @votable.up_vote!(current_user)

    respond_to do |format|
      format.json { render json: { id: @votable.id, score: @votable.score, type: @votable.class.to_s.underscore } }
    end
  end

  def down_vote
    @votable.down_vote!(current_user)

    respond_to do |format|
      format.json { render json: { id: @votable.id, score: @votable.score, type: @votable.class.to_s.underscore } }
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

end