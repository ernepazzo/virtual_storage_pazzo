class Seller::SalesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart

  def index
    @sales = Sale.where(user: current_user).order(created_at: :desc)
  end

  def create
    ActiveRecord::Base.transaction do
      sale = Sale.create!(
        user: current_user,
        # entity_business: current_user.entity_business,
        entity_business: EntityBusiness.first,
        total: @cart.total,
        cost_total: @cart.cart_items.joins(:cost_sheet).sum("(cost_sheets.cost_price_cents / 100.0) * cart_items.quantity")
      )

      @cart.cart_items.each do |item|
        sale.sale_items.create!(
          product_item: item.product_item,
          quantity: item.quantity,
          unit_price: item.unit_price,
          total_price: item.total_price,
          cost_price: item.total_price - (item.cost_sheet.cost_price_cents / 100.0) * item.quantity
        )
      end

      @cart.cart_items.destroy_all
      @cart.update(total: 0)
    end

    # Totales del día
    today_sales = Sale.where(user: current_user, created_at: Time.zone.today.all_day)
    @daily_sales_total = today_sales.sum(:total)
    @daily_profit = today_sales.sum("total - cost_total")

    # Productos más vendidos del día
    @top_products = Sale.joins(sale_items: :product_item)
                        .where(created_at: Time.zone.today.all_day)
                        .group(:product_item_id)
                        .select("product_items.*, COUNT(sale_items.id) as sales_count, SUM(sale_items.quantity) as total_quantity_sold")
                        .order("total_quantity_sold DESC")
                        .limit(5)

    # Productos vendidos del día
    @all_products = Sale.joins(sale_items: :product_item)
                        .joins("LEFT JOIN cost_sheets ON cost_sheets.product_item_id = product_items.id")
                        .where(created_at: Time.zone.today.all_day)
                        .group('product_items.id, cost_sheets.sale_price_cents, cost_sheets.cost_price_cents, cost_sheets.sale_price_currency, cost_sheets.cost_price_currency')
                        .select("product_items.*,
                                cost_sheets.sale_price_cents,
                                cost_sheets.cost_price_cents,
                                cost_sheets.sale_price_currency,
                                cost_sheets.cost_price_currency,
                                COUNT(sale_items.id) as sales_count,
                                SUM(sale_items.quantity) as total_quantity_sold")
                        .order(" total_quantity_sold DESC ")

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace(" cart ", partial: " seller / cart / cart ", locals: { cart: @cart }),
          turbo_stream.replace(" day - sales ", partial: " seller / dashboard / day_sales ", locals: { daily_sales_total: @daily_sales_total }),
          turbo_stream.replace(" net - profit ", partial: " seller / dashboard / net_profit ", locals: { daily_profit: @daily_profit }),
          turbo_stream.replace(" best - sellers ", partial: " seller / dashboard / best_sellers ", locals: { top_products: @top_products }),
          turbo_stream.replace(" all - sellers ", partial: " seller / dashboard / all_sellers ", locals: { all_products: @all_products }),
          turbo_stream.prepend(" flash ", partial: " shared / flash ", locals: { notice: " Venta completada correctamente. " })
        ]
      end
      format.html { redirect_to seller_dashboard_path, notice: " Venta completada correctamente. " }
    end
  rescue => e
    Rails.logger.error " Error al crear la venta: #{e.message}"
    redirect_to seller_dashboard_path, alert: "Ocurrió un error al procesar la venta."
  end

  def show
    @sale = Sale.find(params[:id])
    @sale_items = @sale.sale_items.includes(:product_item)
  end

  private

  def set_cart
    # @cart = Cart.find_or_create_by(user: current_user, entity_business: current_user.entity_business)
    @cart = Cart.find_or_create_by(user: current_user, entity_business: EntityBusiness.first)
  end
end
