# == Schema Information
#
# Table name: carts
#
#  id                 :bigint           not null, primary key
#  total              :decimal(12, 2)   default(0.0)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  entity_business_id :bigint           not null
#  user_id            :bigint           not null
#
# Indexes
#
#  index_carts_on_entity_business_id  (entity_business_id)
#  index_carts_on_user_id             (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (entity_business_id => entity_businesses.id)
#  fk_rails_...  (user_id => users.id)
#
class Cart < ApplicationRecord
  belongs_to :user
  belongs_to :entity_business
  has_many :cart_items, dependent: :destroy

  def total
    cart_items.sum(&:total_price)
  end
end
