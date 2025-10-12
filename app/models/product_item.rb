# == Schema Information
#
# Table name: product_items
#
#  id          :bigint           not null, primary key
#  code        :string(255)      not null
#  description :string(255)
#  name        :string(255)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class ProductItem < ApplicationRecord
  include Imagen
end
