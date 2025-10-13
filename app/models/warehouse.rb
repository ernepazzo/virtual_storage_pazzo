# == Schema Information
#
# Table name: warehouses
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
#  index_warehouses_on_entity_business_id  (entity_business_id)
#
# Foreign Keys
#
#  fk_rails_...  (entity_business_id => entity_businesses.id)
#

require "image_processing/mini_magick"

class Warehouse < ApplicationRecord
  include Imagen

  belongs_to :entity_business
  has_many :cost_sheets, :as => :source, :dependent => :destroy

  validates :name, presence: {
    message: lambda do |object, data|
      "El nombre del Almacén no puede estar vacío."
    end
  }
  validates :code, presence: {
    message: lambda do |object, data|
      "El código del Almacén no puede estar vacío."
    end
  }, uniqueness: {
    message: lambda do |object, data|
      "El código del Almacén debe ser único."
    end
  }


end
