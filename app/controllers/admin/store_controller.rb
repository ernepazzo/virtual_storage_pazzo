class Admin::StoreController < ApplicationController
  before_action :authenticate_user! # Opcional: solo usuarios logueados
  before_action :is_admin?

  before_action :set_store, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token, only: :destroy_block
  layout 'admin'

  def data
    if params[:search].present?
      total = Store.where('name LIKE :search OR code LIKE :search OR description LIKE :search', { search: "%#{params[:search]}%" }).count
      stores = Store.where('name LIKE :search OR code LIKE :search OR description LIKE :search', { search: "%#{params[:search]}%" }).offset(params[:offset]).limit(params[:limit]).order(name: :asc)
    else
      total = Store.count
      stores = Store.offset(params[:offset]).limit(params[:limit]).order(name: :asc)
    end

    rows = []
    stores.each do |store|
      action = ''
      action += "<a class='dropdown-item' href='#{admin_store_show_path(id: store.id)}' data-controller='turbo'><span class='bi bi-eye text-info'></span> Mostrar</a>" # if show_html('admin_access', 'users', 'show')
      action += "<a class='dropdown-item' href='#{admin_store_edit_path(id: store.id)}' data-controller='turbo'><span class='bi bi-pencil text-warning'></span> Editar</a>" # if show_html('admin_access', 'users', 'edit')
      action += "<a class='dropdown-item' href='javascript:;' data-action='admin#delete' data-target='#{admin_store_delete_path(id: store.id)}'><span class='bi bi-trash text-danger' data-action='admin#delete' data-target='#{admin_store_delete_path(id: store.id)}'></span> Eliminar</a>" # if show_html('admin_access', 'users', 'delete')

      # binding.pry
      rows.push(
        id: "<input type='checkbox' value='#{store.id}' class='inputBtnDataTable'>",
        image: "<div style='text-align: center;'><img src='#{store.image.present? ? url_for(store.image) : url_for('/no_images_200_x_200.png')}' class='avatar img-fluid rounded me-1' alt=''></div>",
        name: store.name,
        code: store.code,
        entity_business: store.entity_business&.name,
        description: store.description,
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
  end

  def show
  end

  def new
    @store = Store.new
    @url = admin_store_create_path
    @url_method = 'POST'
  end

  def create
    # unless current_user&.is_granted('role', 'create')
    #   flash[:error] = 'No tienes acceso'
    #   redirect_to admin_path and return
    # end

    @store = Store.new(store_params)
    @store.attach_image_webp(params[:store][:image]) if params[:store][:image].present?
    @form_action = admin_store_create_path
    @url = admin_store_create_path
    @url_method = 'POST'

    if @store.save
      flash[:success] = "Tienda creada satisfactoriamente."
      redirect_to admin_store_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # access_granted('admin_access', 'roles', 'edit')

    @url = admin_store_update_path(id: @store.id)
    @url_method = 'PUT'
  end

  def update
    @store.attach_image_webp(params[:store][:image]) if params[:store][:image].present?

    if @store.update(store_params)
      flash[:success] = "Tienda editada correctamente."
      redirect_to admin_store_path
    else
      @url = admin_store_update_path(id: @store.id)
      @url_method = 'PUT'
      render :edit, status: :unprocessable_entity
      # flash[:warning] = "No se ha podido editar la Tienda."
      # redirect_to admin_store_edit_path(id: @store.id)
    end
  end

  def destroy
    # unless current_user&.is_granted('user', 'delete')
    #   flash[:error] = 'No tienes acceso'
    #   redirect_to admin_user_path and return
    # end

    begin
      @store.destroy
      msg = 'Tienda eliminado.'
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
    # unless current_user&.is_granted('user', 'delete')
    #   flash[:error] = 'No tienes acceso'
    #   redirect_to admin_user_path and return
    # end

    count = 0
    params[:ids].each do |id|
      store = Store.find id
      if store.present?
        count += 1
        store.destroy
      end
    end

    render json: {
      success: true,
      msg: "#{count} Tienda(s) eliminado(s)."
    }
  end

  private

  def set_store
    @store = Store.find_by_id(params[:id])

    if @store.nil?
      flash[:error] = 'Tienda no encontrada.'
      redirect_to admin_store_path
    end
  end

  def store_params
    params.require(:store).permit(:name, :code, :description, :entity_business_id)
  end
end
