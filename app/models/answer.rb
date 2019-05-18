class Answer < ApplicationRecord
  include Votable

  belongs_to :question
  belongs_to :author, class_name: 'User'
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

  default_scope { order(best_solution: :desc) }

  def best_solution!
    best_solution_answer = question.answers.find_by(best_solution: true)
    reward = question.reward

    Answer.transaction do
      best_solution_answer&.update!(best_solution: false)
      self.update!(best_solution: true)
      author.rewards << reward if reward
      author.save!
    end
  end
end
