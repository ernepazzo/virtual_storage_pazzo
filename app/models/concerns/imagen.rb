# app/models/concerns/imageable.rb
# Solo poner en el modelo que quieras 'include Imagen'
module Imagen
  extend ActiveSupport::Concern

  included do
    has_one_attached :image
  end

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