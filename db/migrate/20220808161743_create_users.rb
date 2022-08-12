class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'uuid-ossp'

    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false, index: { unique: true }
      t.date :date_of_birth, null: false, index: true
      t.string :country_code, null: false
      t.integer :current_tier, null: false

      t.timestamps
    end
  end
end
