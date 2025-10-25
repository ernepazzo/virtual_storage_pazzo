# == Schema Information
#
# Table name: sales
#
#  id                 :bigint           not null, primary key
#  cost_total         :decimal(12, 2)   default(0.0)
#  total              :decimal(12, 2)   default(0.0)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  entity_business_id :bigint           not null
#  user_id            :bigint           not null
#
# Indexes
#
#  index_sales_on_entity_business_id  (entity_business_id)
#  index_sales_on_user_id             (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (entity_business_id => entity_businesses.id)
#  fk_rails_...  (user_id => users.id)
#
class Sale < ApplicationRecord
  belongs_to :user
  belongs_to :entity_business
  has_many :sale_items, dependent: :destroy

  validates :total, presence: true

  def profit
    total - cost_total
  end
end
