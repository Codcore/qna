class User < ApplicationRecord
  has_many :questions, foreign_key: :author_id
  has_many :answers, foreign_key: :author_id
  has_many :rewards
  has_many :votes, dependent: :destroy
  has_many :subscriptions
  has_many :subscribed_questions, through: :subscriptions, source: :question

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :omniauthable, omniauth_providers: [:github, :twitter, :google_oauth2]

  has_many :authorizations, dependent: :destroy

  def authorized_for?(resource)
    id == resource.author_id
  end

  def subscribed_for?(question)
    subscribed_questions.where(id: question.id).exists?
  end

  def self.find_for_oauth(auth)
    Services::FindForOAuth.new(auth).call
  end
end
