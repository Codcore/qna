class Reward < ApplicationRecord
  belongs_to :rewardable, polymorphic: true, optional: true
  belongs_to :question
  has_one_attached :image

  validates :name, presence: true
end
