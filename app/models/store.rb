# == Schema Information
#
# Table name: stores
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
#  index_stores_on_entity_business_id  (entity_business_id)
#
# Foreign Keys
#
#  fk_rails_...  (entity_business_id => entity_businesses.id)
#
require "image_processing/mini_magick"

class Store < ApplicationRecord
  belongs_to :entity_business
  include Imagen

  validates :name, presence: {
    message: lambda do |object, data|
      "El nombre de la Tienda no puede estar vacío."
    end
  }
  validates :code, presence: {
    message: lambda do |object, data|
      "El código de la Tienda no puede estar vacío."
    end
  }, uniqueness: {
    message: lambda do |object, data|
      "El código de la Tienda debe ser único."
    end
  }


end
