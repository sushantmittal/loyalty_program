class CreateUserLoyaltyPointsAccumulationInfo < ActiveRecord::Migration[7.0]
  def change
    create_table :user_loyalty_points_accumulation_info do |t|
      t.references :user, null: false, foreign_key: { on_delete: :restrict }
      t.integer :current_cycle_loyalty_points, null: false, default: 0
      t.integer :last_cycle_loyalty_points, null: false, default: 0
      t.jsonb :current_month_info, null: false, default: {}

      t.timestamps
    end
  end
end
