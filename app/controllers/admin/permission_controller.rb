class Admin::PermissionController < ApplicationController
  before_action :authenticate_user! # Opcional: solo usuarios logueados
  before_action :is_admin?
  before_action :set_permission, only: [:edit, :update, :destroy]

  layout 'admin'

  def data
    if params[:search].present?
      total = Permission.where('name LIKE ?', "%#{params[:search]}%").count
      permision = Permission.where('name LIKE ?', "%#{params[:search]}%").offset(params[:offset]).limit(params[:limit]).order('name ASC')
    else
      total = Permission.all.count
      permision = Permission.all.offset(params[:offset]).limit(params[:limit]).order('name ASC')
    end

    rows = []
    permision.each do |p|
      action = ''
      action += "<a class='dropdown-item' href='#{admin_permission_edit_path(id: p.id)}' data-controller='turbo'><span class='bi bi-pencil text-warning'></span> Editar</a>"
      action += "<a class='dropdown-item' href='javascript:;' data-action='admin#delete' data-target='#{admin_permission_delete_path(id: p.id)}'><span class='bi bi-trash text-danger' data-action='admin#delete' data-target='#{admin_permission_delete_path(id: p.id)}'></span> Eliminar</a>" # if show_html('admin_access', 'users', 'delete')
      rows.push(
        id: "<input type='checkbox' value='#{p.id}' class='inputBtnDataTable'>",
        name: p.name,
        type: p.permission_type,
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
    is_granted('access','show')
  end

  def new
    is_granted('access','create')
    @permission = Permission.new
    @view = 'new'
    @url = admin_permission_create_path
    @url_method = 'POST'
  end

  def create
    is_granted('access','create')
    @permission = Permission.new(permission_params)

    if @permission.save
      flash[:success] = 'Permiso creado correctamente'
      redirect_to admin_permissions_path
    else
      @view = 'new'
      @url = admin_permission_create_path
      @url_method = 'POST'
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    is_granted('access','edit')
    @url = admin_permission_update_path(id: @permission.id)
    @url_method = 'PUT'
  end

  def update
    is_granted('access','edit')
    if @permission.update(permission_params)
      flash[:success] = 'Permiso modificado correctamente'
      redirect_to admin_permissions_path
    else
      @url = admin_permission_update_path(id: @permission.id)
      @url_method = 'PUT'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    is_granted('access','delete')
    begin
      @permission.destroy
      msg = 'Permiso eliminado.'
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
    is_granted('access','delete')
    count = 0
    errors = []
    params[:ids].each do |id|
      begin
        Permission.where(id: id).try(:first).try(:destroy)
        count += 1
      rescue StandardError => e
        errors << e.message
      end
    end

    render json: {
      success: true,
      msg: "#{count} Permiso(s) eliminado(s).",
      error: errors
    }
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_permission
    @permission = Permission.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def permission_params
    params.require(:permission).permit(:name, :permission_type)
  end
end
