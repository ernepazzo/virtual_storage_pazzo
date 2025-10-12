class CreateRoleHasAccesses < ActiveRecord::Migration[7.0]
  def change
    create_table :role_has_accesses do |t|
      t.references :role, null: false, foreign_key: true, index: true
      t.references :access, null: false, foreign_key: true, index: true

      t.timestamps
    end
  end
end
