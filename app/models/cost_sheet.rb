# == Schema Information
#
# Table name: cost_sheets
#
#  id                  :bigint           not null, primary key
#  cost_price_cents    :integer          default(0), not null
#  cost_price_currency :string(255)      default("CUP"), not null
#  entry_date          :string(255)
#  sale_amount         :integer
#  sale_price_cents    :integer          default(0), not null
#  sale_price_currency :string(255)      default("CUP"), not null
#  source_type         :string(255)      not null
#  storage_amount      :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  product_item_id     :bigint           not null
#  sale_unit_id        :bigint           not null
#  source_id           :bigint           not null
#  storage_unit_id     :bigint           not null
#
# Indexes
#
#  index_cost_sheets_on_product_item_id  (product_item_id)
#  index_cost_sheets_on_sale_unit_id     (sale_unit_id)
#  index_cost_sheets_on_source           (source_type,source_id)
#  index_cost_sheets_on_storage_unit_id  (storage_unit_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_item_id => product_items.id)
#  fk_rails_...  (sale_unit_id => nom_units.id)
#  fk_rails_...  (storage_unit_id => nom_units.id)
#
class CostSheet < ApplicationRecord
  belongs_to :product_item
  belongs_to :source, polymorphic: true

  belongs_to :store, foreign_key: 'source_id', optional: true
  belongs_to :warehouse, foreign_key: 'source_id', optional: true

  belongs_to :storage_unit, class_name: "NomUnit", foreign_key: "storage_unit_id"
  belongs_to :sale_unit, class_name: "NomUnit", foreign_key: "sale_unit_id"
end
