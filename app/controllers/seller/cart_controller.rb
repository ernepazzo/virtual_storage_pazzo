class Seller::CartController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart

  def index
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def create
    # binding.pry
    product = ProductItem.find(params[:product_item_id])
    cost_sheet = CostSheet.find(params[:cost_sheet_id])

    item = @cart.cart_items.find_or_initialize_by(product_item: product, cost_sheet: cost_sheet)
    item.quantity += params[:quantity].to_i
    item.save

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("cart",
                                                  partial: "seller/cart/cart",
                                                  locals: { cart: @cart })
      end
    end
  end

  def update
    item = @cart.cart_items.find(params[:id])
    item.update(quantity: params[:quantity])
    item.save

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("cart",
                                                  partial: "seller/cart/cart",
                                                  locals: { cart: @cart })
      end
    end
  end

  def destroy
    item = @cart.cart_items.find(params[:id])
    item.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("cart",
                                                  partial: "seller/cart/cart",
                                                  locals: { cart: @cart })
      end
    end
  end

  private

  def set_cart
    # @cart = Cart.find_or_create_by(user: current_user, entity_business: current_user.entity_business)
    @cart = Cart.find_or_create_by(user: current_user, entity_business: EntityBusiness.first)
  end
end
