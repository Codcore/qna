class CreateCommentaries < ActiveRecord::Migration[5.2]
  def change
    create_table :commentaries do |t|
      t.text :body, null: false
      t.belongs_to :user, foreign_key: true
      t.integer :commentable_id
      t.string :commentable_type
      t.index [:commentable_id, :commentable_type]

      t.timestamps
    end
  end
end
