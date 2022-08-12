class CreateUserCumulativeSpendingInfo < ActiveRecord::Migration[7.0]
  def change
    create_table :user_cumulative_spending_info do |t|
      t.references :user, null: false, foreign_key: { on_delete: :restrict }
      t.integer :amount_spent_in_domestic_country, null: false, default: 0
      t.integer :amount_spent_in_foreign_countries, null: false, default: 0
      t.jsonb :transactions_count_info, null: false, default: {}
      t.jsonb :current_quarter_info, null: false, default: {}

      t.timestamps
    end
  end
end
