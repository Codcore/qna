class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'

  enum vote: { down: -1, reset: 0, up: 1 }, _suffix: true
end
