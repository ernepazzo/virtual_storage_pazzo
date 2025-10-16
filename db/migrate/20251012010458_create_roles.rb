class CreateRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :roles do |t|
      t.string :role_type
      t.boolean :admin_access, default: false
      t.integer :priority, default: 1, null: false

      t.timestamps
    end
  end
end
