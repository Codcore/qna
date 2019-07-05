class Question < ApplicationRecord
  include Votable

  has_many :answers, dependent: :destroy
  belongs_to :author, class_name: 'User'
  has_many :links, dependent: :destroy, as: :linkable
  has_many :commentaries, dependent: :destroy, as: :commentable

  has_one :reward, dependent: :destroy

  has_many :subscriptions
  has_many :subscribers, through: :subscriptions, source: :user

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true
  validates :title, uniqueness: true

  after_create :calculate_reputation

  def to_s
    self.title
  end

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end
end
