class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :author, class_name: 'User'

  validates :title, :body, presence: true
  validates :title, uniqueness: true

  def best_solution_answer=(answer)
    if answer.question_id == id
      answers.find_by(best_solution: true)&.update(best_solution: false)
      answer.update(best_solution: true)
    end
  end

  def best_solution_answer
    answers.find_by(best_solution: true)
  end
end
