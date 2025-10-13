class CreateCostSheets < ActiveRecord::Migration[7.0]
  def change
    create_table :cost_sheets do |t|
      t.references :product_item, null: false, foreign_key: true
      t.references :source, null: false, polymorphic: true
      t.monetize :cost_price
      t.monetize :sale_price
      t.integer :storage_amount
      t.references :storage_unit, null: false, foreign_key: { to_table: :nom_units }
      t.integer :sale_amount
      t.references :sale_unit, null: false, foreign_key: { to_table: :nom_units }
      t.string :entry_date

      t.timestamps
    end
  end
end
