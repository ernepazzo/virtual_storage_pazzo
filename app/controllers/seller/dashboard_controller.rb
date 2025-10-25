class Seller::DashboardController < ApplicationController
  layout 'seller'
  before_action :authenticate_user!
  before_action :authorize_seller!

  def index
    # @entity = current_user.entity_business
    @entity = EntityBusiness.first
    @products = @entity.product_items.joins(:cost_sheets)

    @cart = current_cart

    # Totales del día
    today_sales = Sale.where(user: current_user, created_at: Time.zone.today.all_day)
    @daily_sales_total = today_sales.sum(:total)
    @daily_profit = today_sales.sum("total - cost_total")

    # binding.pry
    # Productos más vendidos del día
    # @top_products = ProductItem.joins(:sale_items)
    #                            .where(sale_items: { created_at: Time.zone.today.all_day })
    #                            .group(:id)
    #                            .select("product_items.*, COUNT(sale_items.id) as sales_count")
    #                            .order("sales_count DESC")
    #                            .limit(5)
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
                        .order("total_quantity_sold DESC")
  end

  private

  def authorize_seller!
    # ernepazzo analizar tema permiso para este layout, rol o permiso
    # redirect_to root_path, alert: "No autorizado" unless current_user.role.name == "vendedor"
  end

  def current_cart
    # Cart.find_or_create_by(user: current_user, entity_business: current_user.entity_business)
    Cart.find_or_create_by(user: current_user, entity_business: EntityBusiness.first)
  end
end
