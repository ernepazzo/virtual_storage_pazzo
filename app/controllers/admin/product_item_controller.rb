class Admin::ProductItemController < ApplicationController
  before_action :authenticate_user! # Opcional: solo usuarios logueados
  before_action :is_admin?

  before_action :set_product_item, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token, only: :destroy_block
  layout 'admin'

  def data
    if params[:search].present?
      total = ProductItem.where('name LIKE :search OR code LIKE :search OR description LIKE :search', { search: "%#{params[:search]}%" }).count
      product_items = ProductItem.where('name LIKE :search OR code LIKE :search OR description LIKE :search', { search: "%#{params[:search]}%" }).offset(params[:offset]).limit(params[:limit]).order(name: :asc)
    else
      total = ProductItem.count
      product_items = ProductItem.offset(params[:offset]).limit(params[:limit]).order(name: :asc)
    end

    rows = []
    product_items.each do |product_item|
      action = ''
      action += "<a class='dropdown-item' href='#{admin_product_item_show_path(id: product_item.id)}' data-controller='turbo'><span class='bi bi-eye text-info'></span> Mostrar</a>" # if show_html('admin_access', 'users', 'show')
      action += "<a class='dropdown-item' href='#{admin_product_item_edit_path(id: product_item.id)}' data-controller='turbo'><span class='bi bi-pencil text-warning'></span> Editar</a>" # if show_html('admin_access', 'users', 'edit')
      action += "<a class='dropdown-item' href='javascript:;' data-action='admin#delete' data-target='#{admin_product_item_delete_path(id: product_item.id)}'><span class='bi bi-trash text-danger' data-action='admin#delete' data-target='#{admin_product_item_delete_path(id: product_item.id)}'></span> Eliminar</a>" # if show_html('admin_access', 'users', 'delete')

      # binding.pry
      rows.push(
        id: "<input type='checkbox' value='#{product_item.id}' class='inputBtnDataTable'>",
        image: "<div style='text-align: center;'><img src='#{product_item.image.present? ? url_for(product_item.image) : url_for('/no_images_200_x_200.png')}' class='avatar img-fluid rounded me-1' alt=''></div>",
        name: product_item.name,
        code: product_item.code,
        description: product_item.description,
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
    is_granted('product','show')
  end

  def show
    is_granted('product','show')
  end

  def new
    is_granted('product','create')
    @product_item = ProductItem.new
    @url = admin_product_item_create_path
    @url_method = 'POST'
  end

  def create
    is_granted('product','create')
    # unless current_user&.is_granted('role', 'create')
    #   flash[:error] = 'No tienes acceso'
    #   redirect_to admin_path and return
    # end

    @product_item = ProductItem.new(product_item_params)
    @product_item.attach_image_webp(params[:product_item][:image]) if params[:product_item][:image].present?
    @form_action = admin_product_item_create_path
    @url = admin_product_item_create_path
    @url_method = 'POST'

    if @product_item.save
      flash[:success] = "Producto creado satisfactoriamente."
      redirect_to admin_product_item_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    is_granted('product','edit')
    # access_granted('admin_access', 'roles', 'edit')

    @url = admin_product_item_update_path(id: @product_item.id)
    @url_method = 'PUT'
  end

  def update
    is_granted('product','edit')
    @product_item.attach_image_webp(params[:product_item][:image]) if params[:product_item][:image].present?

    if @product_item.update(product_item_params)
      flash[:success] = "Producto editado correctamente."
      redirect_to admin_product_item_path
    else
      @url = admin_product_item_update_path(id: @product_item.id)
      @url_method = 'PUT'
      render :edit, status: :unprocessable_entity
      # flash[:warning] = "No se ha podido editar le Producto."
      # redirect_to admin_product_item_edit_path(id: @product_item.id)
    end
  end

  def destroy
    is_granted('product','delete')
    # unless current_user&.is_granted('user', 'delete')
    #   flash[:error] = 'No tienes acceso'
    #   redirect_to admin_user_path and return
    # end

    begin
      @product_item.destroy
      msg = 'Producto eliminado.'
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
    is_granted('product','delete')
    # unless current_user&.is_granted('user', 'delete')
    #   flash[:error] = 'No tienes acceso'
    #   redirect_to admin_user_path and return
    # end

    count = 0
    params[:ids].each do |id|
      product_item = ProductItem.find id
      if product_item.present?
        count += 1
        product_item.destroy
      end
    end

    render json: {
      success: true,
      msg: "#{count} Empresa(s) o Negocio(s) eliminado(s)."
    }
  end

  private

  def set_product_item
    @product_item = ProductItem.find_by_id(params[:id])

    if @product_item.nil?
      flash[:error] = 'Producto no encontrado.'
      redirect_to admin_product_item_path
    end
  end

  def product_item_params
    params.require(:product_item).permit(:name, :code, :description)
  end
end
