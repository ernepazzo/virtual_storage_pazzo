class Admin::EntityBusinessController < ApplicationController
  before_action :authenticate_user! # Opcional: solo usuarios logueados
  before_action :is_admin?

  before_action :set_entity_business, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token, only: :destroy_block
  layout 'admin'

  def data
    if params[:search].present?
      total = EntityBusiness.where('name LIKE :search OR code LIKE :search OR description LIKE :search', { search: "%#{params[:search]}%" }).count
      entity_businesses = EntityBusiness.where('name LIKE :search OR code LIKE :search OR description LIKE :search', { search: "%#{params[:search]}%" }).offset(params[:offset]).limit(params[:limit]).order(name: :asc)
    else
      total = EntityBusiness.count
      entity_businesses = EntityBusiness.offset(params[:offset]).limit(params[:limit]).order(name: :asc)
    end

    rows = []
    entity_businesses.each do |entity_business|
      action = ''
      action += "<a class='dropdown-item' href='#{admin_entity_business_show_path(id: entity_business.id)}' data-controller='turbo'><span class='bi bi-eye text-info'></span> Mostrar</a>" # if show_html('admin_access', 'users', 'show')
      action += "<a class='dropdown-item' href='#{admin_entity_business_edit_path(id: entity_business.id)}' data-controller='turbo'><span class='bi bi-pencil text-warning'></span> Editar</a>" # if show_html('admin_access', 'users', 'edit')
      action += "<a class='dropdown-item' href='javascript:;' data-action='admin#delete' data-target='#{admin_entity_business_delete_path(id: entity_business.id)}'><span class='bi bi-trash text-danger' data-action='admin#delete' data-target='#{admin_entity_business_delete_path(id: entity_business.id)}'></span> Eliminar</a>" # if show_html('admin_access', 'users', 'delete')

      # binding.pry
      rows.push(
        id: "<input type='checkbox' value='#{entity_business.id}' class='inputBtnDataTable'>",
        image: entity_business.image.present? ? "<div style='text-align: center;'><img src='#{url_for entity_business.image}' class='avatar img-fluid rounded me-1' alt=''></div>" : "",
        name: entity_business.name,
        code: entity_business.code,
        description: entity_business.description,
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
    @entity_business = EntityBusiness.new
    @url = admin_entity_business_create_path
    @url_method = 'POST'
  end

  def create
    # unless current_user&.is_granted('role', 'create')
    #   flash[:error] = 'No tienes acceso'
    #   redirect_to admin_path and return
    # end

    @entity_business = EntityBusiness.new(entity_business_params)
    @entity_business.attach_image_webp(params[:entity_business][:image]) if params[:entity_business][:image].present?
    @form_action = admin_entity_business_create_path
    @url = admin_entity_business_create_path
    @url_method = 'POST'

    if @entity_business.save
      flash[:success] = "Empresa o Negocio creado satisfactoriamente."
      redirect_to admin_entity_business_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # access_granted('admin_access', 'roles', 'edit')

    @url = admin_entity_business_update_path(id: @entity_business.id)
    @url_method = 'PUT'
  end

  def update
    @entity_business.attach_image_webp(params[:entity_business][:image]) if params[:entity_business][:image].present?

    if @entity_business.update(entity_business_params)
      flash[:success] = "Empresa o Negocio editado correctamente."
      redirect_to admin_entity_business_path
    else
      @url = admin_entity_business_update_path(id: @entity_business.id)
      @url_method = 'PUT'
      flash[:warning] = "No se ha podido editar le Empresa o Negocio."
      redirect_to admin_entity_business_edit_path(id: @entity_business.id)
    end
  end

  def destroy
    # unless current_user&.is_granted('user', 'delete')
    #   flash[:error] = 'No tienes acceso'
    #   redirect_to admin_user_path and return
    # end

    begin
      @entity_business.destroy
      msg = 'Empresa o Negocio eliminado.'
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
      binding.pry
      entity_business = EntityBusiness.find id
      if entity_business.present?
        count += 1
        entity_business.destroy
      end
    end

    render json: {
      success: true,
      msg: "#{count} Empresa(s) o Negocio(s) eliminado(s)."
    }
  end

  private

  def set_entity_business
    @entity_business = EntityBusiness.find_by_id(params[:id])

    if @entity_business.nil?
      flash[:error] = 'Empresa o Negocio no encontrado.'
      redirect_to admin_entity_business_path
    end
  end

  def entity_business_params
    params.require(:entity_business).permit(:name, :code, :description)
  end
end
