class Admin::RoleController < ApplicationController
  before_action :authenticate_user! # Opcional: solo usuarios logueados
  before_action :is_admin?
  before_action :set_role, only: [:edit, :update, :destroy]

  layout 'admin'

  def data
    total = Role.all.count
    roles = Role.all.offset(params[:offset]).limit(params[:limit]).order('priority ASC')

    rows = []
    roles.each do |rol|

      action = ''
      action += "<a class='dropdown-item' href='#{admin_role_edit_url(id: rol.id)}' data-controller='turbo'><span class='bi bi-pencil text-warning'></span> Editar</a>"
      action += "<a class='dropdown-item' href='javascript:;' data-action='admin#delete' data-target='#{admin_role_delete_path(id: rol.id)}'><span class='bi bi-trash text-danger' data-action='admin#delete' data-target='#{admin_role_delete_path(id: rol.id)}'></span> Eliminar</a>" # if show_html('admin_access', 'users', 'delete')

      rows.push(
        id: "<input type='checkbox' value='#{rol.id}' class='inputBtnDataTable'>",
        priority: rol.priority,
        role: rol.role_type,
        admin_access: rol.admin_access? ? "<span class='bi bi-check text-success'></span>" : "<span class='bi bi-x'></span>",
        permissions: rol.get_role_with_access_and_permissions,
        action: "<div class='dropstart'>
                   <a class='btn btn-secondary dropdown-toggle btn-sm' href='#' data-bs-toggle='dropdown' aria-expanded='false'>
                     <span class='bi bi-gear'></span>
                   </a>
                   <div class='dropdown-menu'>
                     #{action}
                   </div>
                 </div>")
    end

    result = { total: total, rows: rows }
    render json: result
  end

  def index
    is_granted('rol','show')
  end

  def new
    is_granted('rol','create')
    @role = Role.new
    @permission = Permission.all.order('name ASC')
    @view = 'new'
    @permission.count.times do
      @role.accesses.build
    end
    @url = admin_role_create_path
    @url_method = 'POST'
  end

  def create
    is_granted('rol','create')
    @role = Role.new(role_params)

    if @role.save
      @role.save_access_for_roles

      flash[:success] = "Rol y Accesos guardados correctamente"
      redirect_to admin_roles_path
    else
      flash[:warning] = "No se ha podido guardar la información. Puede que haya enviado el Nombre del rol vacío o que el mismo ya se encuentre."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    is_granted('rol','edit')
    role_access = RoleHasAccess.where(role_id: @role.id)
    role_access_permited = []
    @view = 'edit'
    @permission = []
    @url = admin_role_update_path(id: @role.id)
    @url_method = 'PUT'
    role_access.each do |rol|
      role_access_permited << rol.access.permission.id
      @permission << rol.access
    end

    new_permission = Permission.where('id NOT IN (?)', role_access_permited)

    if new_permission.count.positive?
      new_permission.each do |permission|
        access = Access.create_or_find_by(permission: permission, can_create: false, can_edit: false, can_show: false, can_delete: false, can_other: false)
        RoleHasAccess.create_or_find_by(role: @role, access: access)
        @permission << access
      end
    end
  end

  def update
    is_granted('rol','edit')
    if @role.update(role_params)
      @role.save_access_for_roles('edit')

      flash[:success] = "Rol y Accesos editados correctamente"
      redirect_to admin_roles_path
    else
      role_access = RoleHasAccess.where(role_id: @role.id)
      role_access_permited = []
      @view = 'edit'
      @permission = []
      @url = admin_role_update_path(id: @role.id)
      @url_method = 'PUT'
      role_access.each do |rol|
        role_access_permited << rol.access.permission.id
        @permission << rol.access
      end

      new_permission = Permission.where('id NOT IN (?)', role_access_permited)

      if new_permission.count.positive?
        new_permission.each do |permission|
          access = Access.create_or_find_by(admin_permission: permission, can_create: false, can_edit: false, can_show: false, can_delete: false, can_other_actions: false)
          RoleHasAccess.create_or_find_by(role: @role, access: access)
          @permission << access
        end
      end

      flash[:warning] = "No se ha podido editar la información"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    is_granted('rol','delete')
    begin
      @role.destroy
      msg = 'Role eliminado.'
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
    is_granted('rol','delete')
    count = 0
    errors = []
    params[:ids].each do |id|
      begin
        Role.where(id: id).try(:first).try(:destroy)
        count += 1
      rescue StandardError => e
        errors << e.message
      end
    end

    render json: {
      success: true,
      msg: "#{count} Rol(es) eliminado(s).",
      error: errors
    }
  end
  private

  def set_role
    @role = Role.find params[:id]
  end

  def role_params
    params.require(:role).permit(:is_default, :role_type, :admin_access, :priority, accesses_attributes: {})
  end

end
