class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.integer :vote, default: 0
      t.belongs_to :user, foreign_key: true
      t.belongs_to :votable, polymorphic: true
    end
  end
end
