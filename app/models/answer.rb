class Answer < ApplicationRecord
  include AuthorizeableResource

  belongs_to :question
  belongs_to :author, class_name: 'User'

  validates :body, presence: true
end
