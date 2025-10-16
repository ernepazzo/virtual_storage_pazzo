class AddIsDefaultToRole < ActiveRecord::Migration[7.0]
  def change
    add_column :roles, :is_default, :boolean, default: false
  end
end
