# == Schema Information
#
# Table name: nom_units
#
#  id         :bigint           not null, primary key
#  code       :string(255)      not null
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class NomUnit < ApplicationRecord
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
