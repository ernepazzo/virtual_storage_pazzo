class Product < ApplicationRecord
  include Favoritable

  ORDER_BY = {
    newest: "created_at DESC",
    expensive: "price DESC",
    cheapest: "price ASC",
  }

  has_one_attached :photo

  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true

  belongs_to :category
  # belongs_to :user, default: -> { Current.user } # para asignar de manera predeterminada al usuario logeado el producto
  belongs_to :user

  def owner?
    user_id == user&.id
  end

  def broadcast
    broadcast_replace_to self, partial: 'products/product_details', locals: { product: self }
  end
  
end
