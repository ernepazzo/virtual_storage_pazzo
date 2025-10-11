class CreateEntityBusinesses < ActiveRecord::Migration[7.0]
  def change
    create_table :entity_businesses do |t|
      t.string :name, null: false
      t.string :code, null: false, unique: true
      t.string :description

      t.timestamps
    end
  end
end
