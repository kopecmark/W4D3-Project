class UsersController < ApplicationController
  before_action :require_login, only: [:show]
  
  def show
    @user = User.find(params[:id])
    render :show # app/views/users/show.html.erb
  end

  def new
  end

  def create
    user = User.new(user_params)

    if user.save
      # call the login method defined in ApplicationController
      login(user)
      redirect_to user_url(user)
    else
      flash.now[:errors] = user.errors.full_messages
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end

  def require_login
    redirect_to new_user_url unless current_user
  end
end
