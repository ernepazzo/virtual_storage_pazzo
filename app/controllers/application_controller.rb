class ApplicationController < ActionController::Base
  # include Authentication
  include Authorization
  include Language
  include Pagy::Backend
  include Error
  before_action :set_current_user

  helper_method :show_html, :is_granted
  def is_admin?
    if !current_user&.role&.admin_access? && (Role.all.count.positive? && Permission.all.count.positive? && User.where('role_id IS NOT NULL').count.positive?)
      flash[:warning] = 'Usted no tiene permisos para ejecutar esta acción'
      redirect_to root_path, alert: 'Usted no tiene permisos para ejecutar esta acción'
    end
  end

  def protect_pages
    redirect_to login_path, alert: t('common.not_logged_in') unless current_user
  end

  def check_access
    if Role.all.count.positive? && Permission.all.count.positive? && User.where('role_id IS NOT NULL').count.positive?
      if user_signed_in?
        case action_name
        when 'index', 'show'
          action = 'show'
        when 'new', 'create'
          action = 'create'
        when 'edit', 'update'
          action = 'edit'
        when 'destroy', 'destroy_block'
          action = 'delete'
        else
          action = 'other'
        end

        unless current_user&.permissions&.[](controller_name)&.[](:"#{action}")
          if !failed_attempt_count
            session[:message] = 'Se ha cerrado su sessión, pues detectamos varios intentos de acceso fallido a recursos no permitidos.'
            redirect_to root_path
          else
            session[:message] = 'Usted no tiene permisos para ejecutar esta acción'
            redirect_to root_path
          end
        end
      else
        if !failed_attempt_count
          session[:message] = 'Se ha cerrado su sessión, pues detectamos varios intentos de acceso fallido a recursos no permitidos. Si este comportamiento continua se le suspendera si cuenta.'
          redirect_to root_path
        else
          session[:message] = 'Se ha cerrado su sessión, pues detectamos varios intentos de acceso fallido a recursos no permitidos. Si este comportamiento continua se le suspendera si cuenta.'
          redirect_to root_path
        end
      end
    end
  end

  def is_granted(action)
    if user_signed_in?
      unless current_user&.permissions&.[](controller_name)&.[](:"#{action}")
        if !failed_attempt_count
          session[:message] = 'Se ha cerrado su sessión, pues detectamos varios intentos de acceso fallido a recursos no permitidos.'
          redirect_to root_path
        else
          session[:message] = 'Usted no tiene permisos para ejecutar esta acción'
          redirect_to root_path
        end
      end
    else
      if !failed_attempt_count
        session[:message] = 'Se ha cerrado su sessión, pues detectamos varios intentos de acceso fallido a recursos no permitidos. Si este comportamiento continua se le suspendera si cuenta.'
        redirect_to root_path
      else
        session[:message] = 'Se ha cerrado su sessión, pues detectamos varios intentos de acceso fallido a recursos no permitidos. Si este comportamiento continua se le suspendera si cuenta.'
        redirect_to root_path
      end
    end
  end

  def show_html(action = nil, permission = nil)
    continue = false
    permission_evaluate = if permission.nil?
                            controller_name
                          else
                            permission
                          end
    if user_signed_in? && current_user&.permissions&.[](permission_evaluate).present?
      if action.nil?
        continue = true
      else
        continue = true if current_user&.permissions&.[](permission_evaluate)&.[](:"#{action}")
      end
    end
    continue
  end

  private

  def set_current_user
    current_user.permissions = current_user.access_and_permissions if current_user.present? && !current_user&.role&.blank?
    Current.user = Current.user
  end

  def failed_attempt_count
    success = true
    if session[:failed_attempt].present?
      if session[:failed_attempt].to_i >= 3
        success = false
      else
        session[:failed_attempt] += 1
      end
    else
      session[:failed_attempt] = 1
    end
    success
  end
end
