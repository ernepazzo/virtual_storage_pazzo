class CreateProductItems < ActiveRecord::Migration[7.0]
  def change
    create_table :product_items do |t|
      t.string :name, null: false
      t.string :code, null: false, unique: true
      t.string :description

      t.timestamps
    end
  end
end
