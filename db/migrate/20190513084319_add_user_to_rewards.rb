class AddUserToRewards < ActiveRecord::Migration[5.2]
  def change
    add_reference :rewards, :user, foreign_key: true
  end
end
