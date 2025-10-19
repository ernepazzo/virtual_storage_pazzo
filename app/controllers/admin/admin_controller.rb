class Admin::AdminController < ApplicationController
  before_action :authenticate_user! # Opcional: solo usuarios logueados
  before_action :is_admin?
  before_action :check_access, except: [:data]
  layout "admin"

  def index
  end
end
