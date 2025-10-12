class CreateStores < ActiveRecord::Migration[7.0]
  def change
    create_table :stores do |t|
      t.string :name, null: false
      t.string :code, null: false, unique: true
      t.string :description
      t.references :entity_business, null: false, foreign_key: true

      t.timestamps
    end
  end
end
