class Reward < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :question

  has_one_attached :image

  validates :name, presence: true
  validate :image, :validate_attached_image

  def validate_attached_image
    errors.add(:image, I18n.translate('errors.reward.validate_attached_image')) unless image.attached?
  end
end
