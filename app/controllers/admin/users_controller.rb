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
      action += "<a class='dropdown-item' href='/admin/users/#{user.id}/perfil' data-controller='turbo'><span class='bi bi-eye text-info'></span> Perfil</a>" # if show_html('admin_access', 'users', 'show')
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

      if (current_user.email == "ernepazzo1212@gmail.com" || current_user.email == "livanmay27@gmail.com" || current_user.email == "duniaosorio88@gmail.com") && user.confirmed_at.nil?
        action += "<a class='dropdown-item' href='/admin/users/#{user.id}/validate'><span class='icon-check text-success'></span> Validar</a>"
      end

      # avatar = if user.avatar.attached?
      #            url_for(user.avatar)
      #          else
      #            ''
      #          end

      admin = '<span class="bi bi-check-lg text-success">'


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
        image: "<div style='text-align: center;'><img src='#{user.image.present? ? url_for(user.image) : url_for('/no_images_200_x_200.png')}' class='avatar img-fluid rounded me-1' alt=''></div>",
        email: user.email,
        whatsapp: user.whatsapp,
        role: user.role&.role_type,
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
    is_granted('user','show')
  end

  def show
    is_granted('user','show')
  end

  def new
    is_granted('user','create')
    @user = User.new
    @view = 'new'
    @url = admin_users_create_path
    @url_method = 'POST'


    render layout: false if turbo_frame_request?
  end

  def create
    is_granted('user','create')
    @user = User.new(user_params)
    # Devise automáticamente encriptará la contraseña
    if @user.save
      # Opcional: enviar email de confirmación si usas confirmable
      @user.send_confirmation_instructions

      flash[:success] = 'Usuario creado'
      redirect_to admin_users_path
    else
      render :new, status: :unprocessable_entity
    end
  end
  def edit
    is_granted('user','edit')
    @url = admin_users_update_path(id: @user.id)
    @url_method = 'POST'

    render layout: false if turbo_frame_request?
  end

  def update
    is_granted('user','edit')
    @url = admin_users_update_path(id: @user.id)
    @url_method = 'POST'

    if @user.update(user_edit_params)
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

  def user_create_params

  end
  def user_params
    params.require(:user).permit(:email, :whatsapp, :role_id, :image, :password, :password_confirmation)
  end
  def user_edit_params
    params.require(:user).permit(:email, :whatsapp, :role_id, :image)
  end

end
