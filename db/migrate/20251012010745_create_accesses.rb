class CreateAccesses < ActiveRecord::Migration[7.0]
  def change
    create_table :accesses do |t|
      t.boolean :can_create, default: false
      t.boolean :can_edit, default: false
      t.boolean :can_show, default: false
      t.boolean :can_delete, default: false
      t.boolean :can_other, default: false

      t.timestamps
    end
  end
end
