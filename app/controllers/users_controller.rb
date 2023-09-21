require 'open-uri'

class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    @user.avatar = AvatarGenerator.generate(user_params[:username])
    puts "Username is: #{@user.username}"
    puts "Avatar is: #{@user.avatar}"

    if @user.save
      session[:user_id] = @user.id
      redirect_to map_path
    else
      render 'sessions/new'
    end
  end

  private

  def user_params
    # params.require(:user).permit(:username, :first_name, :last_name, :email, :password, :password_confirmation)
    params.permit(:username, :first_name, :last_name, :email, :password, :password_confirmation)
  end
end
