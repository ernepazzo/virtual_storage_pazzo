# == Schema Information
#
# Table name: entity_businesses
#
#  id          :bigint           not null, primary key
#  code        :string(255)      not null
#  description :string(255)
#  name        :string(255)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null

require "image_processing/mini_magick"

class EntityBusiness < ApplicationRecord
  include Imagen

  validates :name, presence: {
    message: lambda do |object, data|
      "El nombre de la Empresa o Negocio no puede estar vacío."
    end
  }
  validates :code, presence: {
    message: lambda do |object, data|
      "El código de la Empresa o Negocio no puede estar vacío."
    end
  }, uniqueness: {
    message: lambda do |object, data|
      "El código de la Empresa o Negocio debe ser único."
    end
  }


end
