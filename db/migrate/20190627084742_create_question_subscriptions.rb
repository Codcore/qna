class CreateQuestionSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :question_subscriptions do |t|
      t.references :user
      t.references :question
    end

    add_index :question_subscriptions, [:user_id, :question_id], unique: true
  end
end
