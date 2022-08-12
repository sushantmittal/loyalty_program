class CreateUserRewards < ActiveRecord::Migration[7.0]
  def change
    create_table :user_rewards do |t|
      t.references :user, null: false, foreign_key: { on_delete: :restrict }
      t.integer :reward, null: false
      t.date :will_expire_on
      t.integer :quantity, null: false

      t.timestamps
    end

    add_index :user_rewards, %i[user_id reward will_expire_on], unique: true
  end
end
