class CreateSaleItems < ActiveRecord::Migration[7.2]
  def change
    create_table :sale_items do |t|
      t.references :sale, null: false, foreign_key: true
      t.references :product_item, null: false, foreign_key: true
      t.integer :quantity, default: 1
      t.decimal :unit_price, precision: 12, scale: 2, default: 0.0
      t.decimal :total_price, precision: 12, scale: 2, default: 0.0
      t.decimal :cost_price, precision: 12, scale: 2, default: 0.0
      t.timestamps
    end
  end
end
