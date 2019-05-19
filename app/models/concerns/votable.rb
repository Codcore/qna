module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def up_vote!(user)
    vote = find_vote_for(user)
    return vote.destroy! if vote.down_vote?
    vote.up_vote! unless vote.persisted?
  end

  def down_vote!(user)
    vote = find_vote_for(user)
    return vote.destroy! if vote.up_vote?
    vote.down_vote! unless vote.persisted?
  end

  def score
    votes.sum(:vote)
  end

  private

  def find_vote_for(user)
    votes.exists?(user_id: user.id) ? votes.find_by(user_id: user.id) : self.votes.new(user_id: user.id)
  end
end
