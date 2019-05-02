class AddBestSolutionToAnswers < ActiveRecord::Migration[5.2]
  def change
    add_column :answers, :best_solution, :boolean, default: false
  end
end
