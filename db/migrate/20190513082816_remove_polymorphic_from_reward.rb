class RemovePolymorphicFromReward < ActiveRecord::Migration[5.2]
  def up
    remove_column :rewards, :rewardable_type
    remove_column :rewards, :rewardable_id
  end

  def down
    add_column :rewards, :rewardable_type, :string
    add_column :rewards, :rewardable_id, :integer, foreign_key: true
  end
end
