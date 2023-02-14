class AddNullFalseToProductFields < ActiveRecord::Migration[7.0]
  def change
    change_column_null :products, :title, false
    change_column_null :products, :description, false
    change_column_null :products, :price, false
    change_column_null :products, :category_id, false
    change_column_null :products, :user_id, false
  end
end
