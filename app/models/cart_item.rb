# == Schema Information
#
# Table name: cart_items
#
#  id              :bigint           not null, primary key
#  quantity        :integer          default(0)
#  total_price     :decimal(12, 2)   default(0.0)
#  unit_price      :decimal(12, 2)   default(0.0)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  cart_id         :bigint           not null
#  cost_sheet_id   :bigint           not null
#  product_item_id :bigint           not null
#
# Indexes
#
#  index_cart_items_on_cart_id          (cart_id)
#  index_cart_items_on_cost_sheet_id    (cost_sheet_id)
#  index_cart_items_on_product_item_id  (product_item_id)
#
# Foreign Keys
#
#  fk_rails_...  (cart_id => carts.id)
#  fk_rails_...  (cost_sheet_id => cost_sheets.id)
#  fk_rails_...  (product_item_id => product_items.id)
#
class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product_item
  belongs_to :cost_sheet

  before_save :set_prices

  def set_prices
    self.unit_price = cost_sheet.sale_price_cents / 100.0
    self.total_price = quantity * unit_price.to_d
  end
end
