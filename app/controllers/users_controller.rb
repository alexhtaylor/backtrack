require 'open-uri'

class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    puts "Username is: #{@user.username}"

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
