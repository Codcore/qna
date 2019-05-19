class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'

  validates :vote, presence: true

  enum vote: { down: -1, up: 1 }, _suffix: true
end
