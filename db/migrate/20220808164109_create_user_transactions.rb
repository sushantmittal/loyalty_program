class CreateUserTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :user_transactions do |t|
      t.references :user, null: false, foreign_key: { on_delete: :restrict }
      t.string :country_code, null: false
      t.integer :amount, null: false
      t.text :description

      t.timestamps
    end
  end
end
