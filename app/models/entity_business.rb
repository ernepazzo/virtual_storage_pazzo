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
  has_one_attached :image

  validate :validate_image_size
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

  def validate_image_size
    if image.attached? && image.blob.byte_size > 500.kilobytes
      errors.add(:image, 'El avatar no puede superar los 500kb de almacenamiento.')
    end
  end

  def attach_image_webp(input_image)
    processed_image = convert_to_webp(input_image)

    image.attach(
      io: File.open(processed_image.path),
      filename: "#{input_image.original_filename.split('.').first}.webp",
      content_type: "image/webp"
    )
  end

  private

  def convert_to_webp(input_image)
    ImageProcessing::MiniMagick
      .source(input_image)
      .convert("webp")
      .saver(quality: 80)
      .call
  end
end
