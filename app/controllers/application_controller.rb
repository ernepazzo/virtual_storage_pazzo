class ApplicationController < ActionController::Base
  # include Authentication
  include Authorization
  include Language
  include Pagy::Backend
  include Error

  before_action :set_current_user

  def is_admin?
    unless current_user&.admin?
      redirect_to root_path, alert: "Acceso denegado."
    end
  end

  def protect_pages
    redirect_to login_path, alert: t('common.not_logged_in') unless current_user
  end

  private

  def set_current_user
    Current.user = Current.user
  end
end
