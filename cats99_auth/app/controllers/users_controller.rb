class UsersController < ApplicationController
  
  def new
    render :new
  end
  
  def create
    user = User.new(user_params)
    if user.save
      # put login logic here
      redirect_to cats_url
    else
      render json: user.errors
    end
    
  end
  
  
  private
  
  def user_params
    params.require(:user).permit(:user_name, :password)
    
    
  end
  
end
