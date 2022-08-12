class CreateUserLoyaltyPointsTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :user_loyalty_points_transactions do |t|
      t.references :user, null: false, foreign_key: { on_delete: :restrict }
      t.integer :loyalty_points, null: false
      t.text :description

      t.timestamps
    end
  end
end
