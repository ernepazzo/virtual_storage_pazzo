# == Schema Information
#
# Table name: product_items
#
#  id                 :bigint           not null, primary key
#  code               :string(255)      not null
#  description        :string(255)
#  name               :string(255)      not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  entity_business_id :bigint           not null
#
# Indexes
#
#  index_product_items_on_entity_business_id  (entity_business_id)
#
# Foreign Keys
#
#  fk_rails_...  (entity_business_id => entity_businesses.id)
#
class ProductItem < ApplicationRecord
  include Imagen

  belongs_to :entity_business
  has_many :cart_items
  has_many :cost_sheets
end
