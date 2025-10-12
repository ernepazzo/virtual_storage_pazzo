class CreateNomUnits < ActiveRecord::Migration[7.0]
  def change
    create_table :nom_units do |t|
      t.string :name, null: false
      t.string :code, null: false, unique: true

      t.timestamps
    end
  end
end
