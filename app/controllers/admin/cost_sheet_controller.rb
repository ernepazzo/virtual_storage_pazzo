class Admin::CostSheetController < ApplicationController
  before_action :authenticate_user! # Opcional: solo usuarios logueados
  before_action :is_admin?

  before_action :set_cost_sheet, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token, only: :destroy_block
  layout 'admin'

  include ActionView::Helpers::NumberHelper

  def data
    if params[:search].present?
      total = CostSheet.where('name LIKE :search OR code LIKE :search OR description LIKE :search', { search: "%#{params[:search]}%" }).count
      cost_sheets = CostSheet.where('name LIKE :search OR code LIKE :search OR description LIKE :search', { search: "%#{params[:search]}%" }).offset(params[:offset]).limit(params[:limit]).order(name: :asc)
    else
      total = CostSheet.count
      cost_sheets = CostSheet.offset(params[:offset]).limit(params[:limit]).order(created_at: :desc)
    end

    rows = []
    cost_sheets.each do |cost_sheet|
      action = ''
      action += "<a class='dropdown-item' href='#{admin_cost_sheet_show_path(id: cost_sheet.id)}' data-controller='turbo'><span class='bi bi-eye text-info'></span> Mostrar</a>" # if show_html('admin_access', 'users', 'show')
      action += "<a class='dropdown-item' href='#{admin_cost_sheet_edit_path(id: cost_sheet.id)}' data-controller='turbo'><span class='bi bi-pencil text-warning'></span> Editar</a>" # if show_html('admin_access', 'users', 'edit')
      action += "<a class='dropdown-item' href='javascript:;' data-action='admin#delete' data-target='#{admin_cost_sheet_delete_path(id: cost_sheet.id)}'><span class='bi bi-trash text-danger' data-action='admin#delete' data-target='#{admin_cost_sheet_delete_path(id: cost_sheet.id)}'></span> Eliminar</a>" # if show_html('admin_access', 'users', 'delete')

      # binding.pry
      rows.push(
        id: "<input type='checkbox' value='#{cost_sheet.id}' class='inputBtnDataTable'>",
        # image: "<div style='text-align: center;'><img src='#{cost_sheet.image.present? ? url_for(cost_sheet.image) : url_for('/no_images_200_x_200.png')}' class='avatar img-fluid rounded me-1' alt=''></div>",
        product_item: cost_sheet.product_item.name,
        source: cost_sheet.source.name,
        cost_price: number_to_currency((cost_sheet.cost_price_cents / 100), unit: cost_sheet.cost_price_currency, separator: ',', format: '%n %u'),
        sale_price: number_to_currency((cost_sheet.sale_price_cents / 100), unit: cost_sheet.sale_price_currency, separator: ',', format: '%n %u'),
        storage_amount: cost_sheet.storage_amount,
        storage_unit: cost_sheet.storage_unit.name,
        sale_amount: cost_sheet.sale_amount,
        sale_unit: cost_sheet.sale_unit.name,
        entry_date: cost_sheet.entry_date,
        action: "<div class='dropstart'>
                   <a class='btn btn-secondary dropdown-toggle btn-sm' href='#' data-bs-toggle='dropdown' aria-expanded='false'>
                     <span class='bi bi-gear'></span>
                   </a>
                   <div class='dropdown-menu'>
                     #{action}
                   </div>
                 </div>"
      )
    end

    result = { total: total, rows: rows }
    render json: result
  end

  def index
    is_granted('cost_sheet','show')
  end

  def show
    is_granted('cost_sheet','show')
  end

  def new
    is_granted('cost_sheet','create')
    @cost_sheet = CostSheet.new
    @url = admin_cost_sheet_create_path
    @url_method = 'POST'
  end

  def create
    is_granted('cost_sheet','create')
    # unless current_user&.is_granted('role', 'create')
    #   flash[:error] = 'No tienes acceso'
    #   redirect_to admin_path and return
    # end

    @cost_sheet = CostSheet.new(cost_sheet_params)
    @form_action = admin_cost_sheet_create_path
    @url = admin_cost_sheet_create_path
    @url_method = 'POST'

    if @cost_sheet.save
      flash[:success] = "Ficha de Costo creada satisfactoriamente."
      redirect_to admin_cost_sheet_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    is_granted('cost_sheet','edit')
    # access_granted('admin_access', 'roles', 'edit')

    @url = admin_cost_sheet_update_path(id: @cost_sheet.id)
    @url_method = 'PUT'
  end

  def update
    is_granted('cost_sheet','edit')
    if @cost_sheet.update(cost_sheet_params)
      flash[:success] = "Ficha de Costo editada correctamente."
      redirect_to admin_cost_sheet_path
    else
      @url = admin_cost_sheet_update_path(id: @cost_sheet.id)
      @url_method = 'PUT'
      render :edit, status: :unprocessable_entity
      # flash[:warning] = "No se ha podido editar la Ficha de Costo."
      # redirect_to admin_cost_sheet_edit_path(id: @cost_sheet.id)
    end
  end

  def destroy
    is_granted('cost_sheet','delete')
    # unless current_user&.is_granted('user', 'delete')
    #   flash[:error] = 'No tienes acceso'
    #   redirect_to admin_user_path and return
    # end

    begin
      @cost_sheet.destroy
      msg = 'Ficha de Costo eliminada.'
      success = true
    rescue StandardError => e
      success = false
      msg = e.message
    end

    render json: {
      success: success,
      msg: msg
    }
  end

  def destroy_block
    is_granted('cost_sheet','delete')
    # unless current_user&.is_granted('user', 'delete')
    #   flash[:error] = 'No tienes acceso'
    #   redirect_to admin_user_path and return
    # end

    count = 0
    params[:ids].each do |id|
      cost_sheet = CostSheet.find id
      if cost_sheet.present?
        count += 1
        cost_sheet.destroy
      end
    end

    render json: {
      success: true,
      msg: "#{count} Ficha(s) de Costo eliminada(s)."
    }
  end

  private

  def set_cost_sheet
    @cost_sheet = CostSheet.find_by_id(params[:id])

    if @cost_sheet.nil?
      flash[:error] = 'Ficha de Costo no encontrada.'
      redirect_to admin_cost_sheet_path
    end
  end

  def cost_sheet_params
    params.require(:cost_sheet).permit(:product_item_id, :source_type, :source_id, :cost_price_cents, :sale_price_cents, :storage_amount, :storage_unit_id, :sale_amount, :sale_unit_id, :entry_date)
  end
end
