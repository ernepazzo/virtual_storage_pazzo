class AddPermissionToAccess < ActiveRecord::Migration[7.0]
  def change
    add_reference :accesses, :permission, null: false, foreign_key: true, index: true
  end
end
