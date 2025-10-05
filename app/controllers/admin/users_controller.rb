class Admin::UsersController < ApplicationController
  before_action :authenticate_user!   # Opcional: solo usuarios logueados
  before_action :is_admin?

  before_action :set_user, only: [:show, :edit, :update]
  layout 'admin'

  def data
    if params[:search].present?
      total = User.where('email LIKE :search', { search: "%#{params[:search]}%" }).count
      users = User.where('email LIKE :search', { search: "%#{params[:search]}%" }).offset(params[:offset]).limit(params[:limit]).order('id ASC')
    else
      total = User.count
      users = User.offset(params[:offset]).limit(params[:limit]).order('id ASC')
    end

    rows = []

    users.each do |user|
      action = ''
      action += "<a class='dropdown-item' href='/admin/users/#{user.id}/perfil'><span class='bi bi-eye text-info'></span> Perfil</a>" # if show_html('admin_access', 'users', 'show')
      action += "<a class='dropdown-item' href='/#{I18n.locale}/admin/users/#{user.id}/edit' data-controller='turbo'><span class='bi bi-pencil text-warning'></span> Editar</a>" # if show_html('admin_access', 'users', 'edit')
      action += "<a class='dropdown-item' href='javascript:;' data-action='dataTable#delete' data-target='/admin/users/#{user.id}'><span class='bi bi-trash text-danger' data-action='dataTable#delete' data-target='/admin/users/#{user.id}'></span> Eliminar</a>" # if show_html('admin_access', 'users', 'delete')

      # if show_html('admin_access', 'users', 'other')
      #   action += "<div class='dropdown-divider'></div>"
      #   unless user.is_commercial
      #     action += "  <a title='Crear usuario comercial' href='javascript:;' class='dropdown-item' data-action='dataTable#commercial' data-target='/admin/commercial/#{user.id}/create'><span class='fa fa-user-secret' data-action='dataTable#commercial' data-target='/admin/commercial/#{user.id}/create'></span> Comercial</a>"
      #   end
      #
      #   unless user.email_is_validate?
      #     action += "<a title='Enviar email de verificación' class='dropdown-item' href='/admin/users/validate/email?redirect=admin&user_id=#{user.id}' ><span class='fa fa-envelope text-success'></span> Reenviar email</a>"
      #   end
      #
      #   block = Block.block_user(user.email, user.mac_address)
      #   if block.blank?
      #     action += "<a class='dropdown-item' href='javascript:;' data-action='dataTable#block' data-target='/admin/users/#{user.id}'><span class='icon-lock' data-action='dataTable#block' data-target='/admin/users/#{user.id}'></span> Bloquear</a>"
      #   end
      # end

      if current_user.email == "ernepazzo1212@gmail.com" && user.confirmed_at.nil?
        action += "<a class='dropdown-item' href='/admin/users/#{user.id}/validate'><span class='icon-check text-success'></span> Validar</a>"
      end

      # avatar = if user.avatar.attached?
      #            url_for(user.avatar)
      #          else
      #            ''
      #          end

      admin = if user.admin
                '<span class="bi bi-check text-success">'
              else
                '<span class="bi bi-times text-danger">'
              end

      # commercial = if user.is_commercial
      #                '<span class="fa fa-check text-success">'
      #              else
      #                ''
      #              end

      # role = if user.role.blank?
      #          'Sin permisos definidos'
      #        else
      #          user.role.get_role_with_access_and_permissions
      #        end

      rows.push(
        id: user.id,
        email: user.email,
        whatsapp: user.whatsapp,
        admin: admin,
        description: 'Test',
        action: "<div class='dropstart'>
                   <a class='btn btn-secondary dropdown-toggle btn-sm' href='#' data-bs-toggle='dropdown' aria-expanded='false'>
                     <span class='bi bi-gear'></span>
                   </a>
                   <div class='dropdown-menu'>
                     #{action}
                   </div>
                 </div>"
      )

      # action: '
      #     <div class="btn-group dropstart">
      #       <button type="button" class="btn btn-secondary dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
      #         Dropstart
      #       </button>
      #       <ul class="dropdown-menu">
      #         <li><a class="dropdown-item" href="#">Menu item</a></li>
      #         <li><a class="dropdown-item" href="#">Menu item</a></li>
      #         <li><a class="dropdown-item" href="#">Menu item</a></li>
      #       </ul>
      #     </div>
      #     '
    end

    result = { total: total, rows: rows }
    render json: result
  end

  def index
  end

  def show
  end

  def edit
    @url = admin_users_update_path(id: @user.id)
    @url_method = 'POST'

    render layout: false if turbo_frame_request?
  end

  def update
    if @user.update(user_params)
      flash[:success] = "Usuario actualizado."
      redirect_to admin_users_path
    else
      @form_action = admin_users_update_path(id: @user.id)
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find_by_id(params[:id])

    if @user.nil?
      flash[:error] = 'Usuario no encontrado.'
      redirect_to admin_users_path
    end
  end

  def user_params
    params.require(:user).permit(:email, :whatsapp, :admin)
  end
end
