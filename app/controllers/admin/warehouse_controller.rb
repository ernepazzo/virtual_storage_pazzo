class Admin::WarehouseController < ApplicationController
  before_action :authenticate_user! # Opcional: solo usuarios logueados
  before_action :is_admin?

  before_action :set_warehouse, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token, only: :destroy_block
  layout 'admin'

  def data
    if params[:search].present?
      total = Warehouse.where('name LIKE :search OR code LIKE :search OR description LIKE :search', { search: "%#{params[:search]}%" }).count
      warehouses = Warehouse.where('name LIKE :search OR code LIKE :search OR description LIKE :search', { search: "%#{params[:search]}%" }).offset(params[:offset]).limit(params[:limit]).order(name: :asc)
    else
      total = Warehouse.count
      warehouses = Warehouse.offset(params[:offset]).limit(params[:limit]).order(name: :asc)
    end

    rows = []
    warehouses.each do |warehouse|
      action = ''
      action += "<a class='dropdown-item' href='#{admin_warehouse_show_path(id: warehouse.id)}' data-controller='turbo'><span class='bi bi-eye text-info'></span> Mostrar</a>" # if show_html('admin_access', 'users', 'show')
      action += "<a class='dropdown-item' href='#{admin_warehouse_edit_path(id: warehouse.id)}' data-controller='turbo'><span class='bi bi-pencil text-warning'></span> Editar</a>" # if show_html('admin_access', 'users', 'edit')
      action += "<a class='dropdown-item' href='javascript:;' data-action='admin#delete' data-target='#{admin_warehouse_delete_path(id: warehouse.id)}'><span class='bi bi-trash text-danger' data-action='admin#delete' data-target='#{admin_warehouse_delete_path(id: warehouse.id)}'></span> Eliminar</a>" # if show_html('admin_access', 'users', 'delete')

      # binding.pry
      rows.push(
        id: "<input type='checkbox' value='#{warehouse.id}' class='inputBtnDataTable'>",
        image: "<div style='text-align: center;'><img src='#{warehouse.image.present? ? url_for(warehouse.image) : url_for('/no_images_200_x_200.png')}' class='avatar img-fluid rounded me-1' alt=''></div>",
        name: warehouse.name,
        code: warehouse.code,
        entity_business: warehouse.entity_business&.name,
        description: warehouse.description,
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
    is_granted('warehouse','show')
  end

  def show
    is_granted('warehouse','show')
  end

  def new
     is_granted('warehouse','create')
    @warehouse = Warehouse.new
    @url = admin_warehouse_create_path
    @url_method = 'POST'
  end

  def create
     is_granted('warehouse','create')
    # unless current_user&.is_granted('role', 'create')
    #   flash[:error] = 'No tienes acceso'
    #   redirect_to admin_path and return
    # end

    @warehouse = Warehouse.new(warehouse_params)
    @warehouse.attach_image_webp(params[:warehouse][:image]) if params[:warehouse][:image].present?
    @form_action = admin_warehouse_create_path
    @url = admin_warehouse_create_path
    @url_method = 'POST'

    if @warehouse.save
      flash[:success] = "Almacén creado satisfactoriamente."
      redirect_to admin_warehouse_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
     is_granted('warehouse','edit')
    # access_granted('admin_access', 'roles', 'edit')

    @url = admin_warehouse_update_path(id: @warehouse.id)
    @url_method = 'PUT'
  end

  def update
     is_granted('warehouse','edit')
    @warehouse.attach_image_webp(params[:warehouse][:image]) if params[:warehouse][:image].present?

    if @warehouse.update(warehouse_params)
      flash[:success] = "Almacén editado correctamente."
      redirect_to admin_warehouse_path
    else
      @url = admin_warehouse_update_path(id: @warehouse.id)
      @url_method = 'PUT'
      render :edit, status: :unprocessable_entity
      # flash[:warning] = "No se ha podido editar le Almacén."
      # redirect_to admin_warehouse_edit_path(id: @warehouse.id)
    end
  end

  def destroy
     is_granted('warehouse','delete')
    # unless current_user&.is_granted('user', 'delete')
    #   flash[:error] = 'No tienes acceso'
    #   redirect_to admin_user_path and return
    # end

    begin
      @warehouse.destroy
      msg = 'Almacén eliminado.'
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
     is_granted('warehouse','delete')
    # unless current_user&.is_granted('user', 'delete')
    #   flash[:error] = 'No tienes acceso'
    #   redirect_to admin_user_path and return
    # end

    count = 0
    params[:ids].each do |id|
      warehouse = Warehouse.find id
      if warehouse.present?
        count += 1
        warehouse.destroy
      end
    end

    render json: {
      success: true,
      msg: "#{count} Almacén(es) eliminado(s)."
    }
  end

  private

  def set_warehouse
    @warehouse = Warehouse.find_by_id(params[:id])

    if @warehouse.nil?
      flash[:error] = 'Almacén no encontrado.'
      redirect_to admin_warehouse_path
    end
  end

  def warehouse_params
    params.require(:warehouse).permit(:name, :code, :description, :entity_business_id)
  end
end
