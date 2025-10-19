class AddFielEntityBusinessIdToProductItem < ActiveRecord::Migration[7.0]
  def up
    # 1. Asegurarnos de que la tabla entity_businesses exista
    unless table_exists?(:entity_businesses)
      raise "La tabla 'entity_businesses' no existe. Créala primero."
    end

    # 2. Agregar la columna SIN restricción de clave foránea aún (y permitiendo NULL)
    add_reference :product_items, :entity_business, null: true, foreign_key: false

    # 3. Verificar si hay al menos un entity_business
    default_entity_business = EntityBusiness.first

    # 4. Si no hay ninguno, crear uno por defecto
    unless default_entity_business
      default_entity_business = EntityBusiness.create!(
        name: "Default Business",
        code: "DEFAULT_BUS"
      # Añade otros campos obligatorios si tu tabla los tiene, como description, etc.
      )
    end

    # 5. Asignar ese entity_business a todos los product_items existentes
    ProductItem.where(entity_business_id: nil).update_all(entity_business_id: default_entity_business.id)

    # 6. AHORA sí: agregar la restricción de clave foránea
    add_foreign_key :product_items, :entity_businesses, column: :entity_business_id

    # 7. Finalmente, hacer la columna NOT NULL
    change_column_null :product_items, :entity_business_id, false
  end

  def down
    # Revertir en orden inverso
    change_column_null :product_items, :entity_business_id, true
    remove_foreign_key :product_items, column: :entity_business_id
    remove_reference :product_items, :entity_business, foreign_key: false
  end
end
