class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User'
  has_many_attached :files

  validates :body, presence: true

  default_scope { order(best_solution: :desc) }

  def best_solution!
    best_solution_answer = question.answers.find_by(best_solution: true)
    Answer.transaction do
      best_solution_answer&.update!(best_solution: false)
      self.update!(best_solution: true)
    end
  end
end
