class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :username, null: false

      t.timestamps

      t.string :api_key, index: { unique: true }
    end
  end
end
