class UsersController < ApplicationController
  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to map_path
    else
      render 'sessions/new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
