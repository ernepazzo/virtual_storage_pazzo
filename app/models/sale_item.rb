# == Schema Information
#
# Table name: sale_items
#
#  id              :bigint           not null, primary key
#  cost_price      :decimal(12, 2)   default(0.0)
#  quantity        :integer          default(1)
#  total_price     :decimal(12, 2)   default(0.0)
#  unit_price      :decimal(12, 2)   default(0.0)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  product_item_id :bigint           not null
#  sale_id         :bigint           not null
#
# Indexes
#
#  index_sale_items_on_product_item_id  (product_item_id)
#  index_sale_items_on_sale_id          (sale_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_item_id => product_items.id)
#  fk_rails_...  (sale_id => sales.id)
#
class SaleItem < ApplicationRecord
  belongs_to :sale
  belongs_to :product_item

  def profit
    total_price - (cost_price * quantity)
  end
end
