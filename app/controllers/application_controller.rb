class ApplicationController < ActionController::Base
  # include Authentication
  include Authorization
  include Language
  include Pagy::Backend
  include Error
  before_action :set_current_user

  def is_admin?
    unless current_user&.role&.admin_access?
      flash[:warning] = 'Usted no tiene permisos para ejecutar esta acción'
      redirect_to root_path, alert: 'Usted no tiene permisos para ejecutar esta acción'
    end
  end

  def protect_pages
    redirect_to login_path, alert: t('common.not_logged_in') unless current_user
  end

  def is_granted(permission, action)
    if user_signed_in?
      unless current_user&.permissions&.[](permission)&.[](:"#{action}")
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
