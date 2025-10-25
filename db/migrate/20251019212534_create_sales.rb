class CreateSales < ActiveRecord::Migration[7.2]
  def change
    create_table :sales do |t|
      t.references :user, null: false, foreign_key: true
      t.references :entity_business, null: false, foreign_key: true
      t.decimal :total, precision: 12, scale: 2, default: 0.0
      t.decimal :cost_total, precision: 12, scale: 2, default: 0.0
      t.timestamps
    end
  end
end
