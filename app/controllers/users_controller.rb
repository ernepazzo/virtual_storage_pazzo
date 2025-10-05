class UsersController < ApplicationController
  # skip_before_action :protect_pages, only: :show

  def show
    # el "!" en el find_by, va a hacer k sino encuentra lanza una excepcion y todo lo demás se va a detener
    @user = User.find_by!(id: params[:username])
  end
end