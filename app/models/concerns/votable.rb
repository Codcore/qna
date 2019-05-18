module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def up_vote!(user)
    vote = find_vote_for(user)
    vote.up_vote! if vote.reset_vote?
    vote.reset_vote! if vote.down_vote?
  end

  def down_vote!(user)
    vote = find_vote_for(user)
    vote.down_vote! if vote.reset_vote?
    vote.reset_vote! if vote.up_vote?
  end

  def score
    votes.where(vote: Vote.votes[:up]).count - votes.where(vote: Vote.votes[:down]).count
  end

  private

  def find_vote_for(user)
    votes.exists?(user_id: user.id) ? votes.find_by(user_id: user.id) : self.votes.new(user_id: user.id)
  end
end
