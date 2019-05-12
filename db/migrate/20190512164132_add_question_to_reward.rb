class AddQuestionToReward < ActiveRecord::Migration[5.2]
  def change
    add_reference :rewards, :question, foreign_key: true
  end
end
