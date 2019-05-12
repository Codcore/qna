class CreateRewards < ActiveRecord::Migration[5.2]
  def change
    create_table :rewards do |t|
      t.string :name
      t.belongs_to :rewardable, polymorphic: true

      t.timestamps
    end
  end
end
