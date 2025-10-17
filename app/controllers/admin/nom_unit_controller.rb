class Admin::NomUnitController < ApplicationController
  before_action :authenticate_user! # Opcional: solo usuarios logueados
  before_action :is_admin?

  before_action :set_nom_unit, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token, only: :destroy_block
  layout 'admin'

  def data
    if params[:search].present?
      total = NomUnit.where('name LIKE :search OR code LIKE :search', { search: "%#{params[:search]}%" }).count
      nom_units = NomUnit.where('name LIKE :search OR code LIKE :search', { search: "%#{params[:search]}%" }).offset(params[:offset]).limit(params[:limit]).order(name: :asc)
    else
      total = NomUnit.count
      nom_units = NomUnit.offset(params[:offset]).limit(params[:limit]).order(name: :asc)
    end

    rows = []
    nom_units.each do |nom_unit|
      action = ''
      action += "<a class='dropdown-item' href='#{admin_nom_unit_show_path(id: nom_unit.id)}' data-controller='turbo'><span class='bi bi-eye text-info'></span> Mostrar</a>" # if show_html('admin_access', 'users', 'show')
      action += "<a class='dropdown-item' href='#{admin_nom_unit_edit_path(id: nom_unit.id)}' data-controller='turbo'><span class='bi bi-pencil text-warning'></span> Editar</a>" # if show_html('admin_access', 'users', 'edit')
      action += "<a class='dropdown-item' href='javascript:;' data-action='admin#delete' data-target='#{admin_nom_unit_delete_path(id: nom_unit.id)}'><span class='bi bi-trash text-danger' data-action='admin#delete' data-target='#{admin_nom_unit_delete_path(id: nom_unit.id)}'></span> Eliminar</a>" # if show_html('admin_access', 'users', 'delete')

      # binding.pry
      rows.push(
        id: "<input type='checkbox' value='#{nom_unit.id}' class='inputBtnDataTable'>",
        # image: "<div style='text-align: center;'><img src='#{nom_unit.image.present? ? url_for(nom_unit.image) : url_for('/no_images_200_x_200.png')}' class='avatar img-fluid rounded me-1' alt=''></div>",
        name: nom_unit.name,
        code: nom_unit.code,
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
    is_granted('unity','show')
  end

  def show
    is_granted('unity','show')
  end

  def new
    is_granted('unity','create')
    @nom_unit = NomUnit.new
    @url = admin_nom_unit_create_path
    @url_method = 'POST'
  end

  def create
    is_granted('unity','create')
    # unless current_user&.is_granted('role', 'create')
    #   flash[:error] = 'No tienes acceso'
    #   redirect_to admin_path and return
    # end

    @nom_unit = NomUnit.new(nom_unit_params)
    @form_action = admin_nom_unit_create_path
    @url = admin_nom_unit_create_path
    @url_method = 'POST'

    if @nom_unit.save
      flash[:success] = "Unidad de Medida creada satisfactoriamente."
      redirect_to admin_nom_unit_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    is_granted('unity','edit')
    # access_granted('admin_access', 'roles', 'edit')

    @url = admin_nom_unit_update_path(id: @nom_unit.id)
    @url_method = 'PUT'
  end

  def update
    is_granted('unity','edit')
    if @nom_unit.update(nom_unit_params)
      flash[:success] = "Unidad de Medida editada correctamente."
      redirect_to admin_nom_unit_path
    else
      @url = admin_nom_unit_update_path(id: @nom_unit.id)
      @url_method = 'PUT'
      render :edit, status: :unprocessable_entity
      # flash[:warning] = "No se ha podido editar le Unidad de Medida."
      # redirect_to admin_nom_unit_edit_path(id: @nom_unit.id)
    end
  end

  def destroy
    is_granted('unity','delete')
    # unless current_user&.is_granted('user', 'delete')
    #   flash[:error] = 'No tienes acceso'
    #   redirect_to admin_user_path and return
    # end

    begin
      @nom_unit.destroy
      msg = 'Unidad de Medida eliminada.'
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
    is_granted('unity','delete')
    # unless current_user&.is_granted('user', 'delete')
    #   flash[:error] = 'No tienes acceso'
    #   redirect_to admin_user_path and return
    # end

    count = 0
    params[:ids].each do |id|
      nom_unit = NomUnit.find id
      if nom_unit.present?
        count += 1
        nom_unit.destroy
      end
    end

    render json: {
      success: true,
      msg: "#{count} Empresa(s) o Negocio(s) eliminado(s)."
    }
  end

  private

  def set_nom_unit
    @nom_unit = NomUnit.find_by_id(params[:id])

    if @nom_unit.nil?
      flash[:error] = 'Unidad de Medida no encontrada.'
      redirect_to admin_nom_unit_path
    end
  end

  def nom_unit_params
    params.require(:nom_unit).permit(:name, :code)
  end
end
