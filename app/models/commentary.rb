class Commentary < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
  belongs_to :commentable, polymorphic: true, touch: true

  default_scope { order(id: :asc) }

  validates :body, presence: true, length: { minimum: 20 }

  alias_attribute :author_id, :user_id
end
