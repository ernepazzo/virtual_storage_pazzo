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
  belongs_to :entity_business
  has_one_attached :image

  validate :validate_image_size
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

  def validate_image_size
    if image.attached? && image.blob.byte_size > 500.kilobytes
      errors.add(:image, 'La imagen no puede superar los 500kb de almacenamiento.')
      image = nil
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
