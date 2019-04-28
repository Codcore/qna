class Question < ApplicationRecord
  include AuthorizeableResource

  has_many :answers, dependent: :destroy
  belongs_to :author, class_name: 'User'

  validates :title, :body, presence: true
  validates :title, uniqueness: true
end
