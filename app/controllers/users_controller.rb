require 'open-uri'

class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    @user.instagram_account = params[:instagram_account] != "1"
    @user.avatar = @user.instagram_account ? get_avatar(user_params[:username]) : "/assets/backpack-icon-large-#{rand(1..10)}.png"
    puts "Username is: #{@user.username}"
    puts "Avatar is: #{@user.avatar}"

    if @user.avatar != 'f' && @user.save
      # this is @user.avatar = "f" thing is a terrible fix, for some reason line 25 is causing avatar to be set to "f" instead of not set at all
      session[:user_id] = @user.id
      redirect_to map_path
    else
      render 'sessions/new'
    end
  end

  def get_avatar(username)
    if AvatarGenerator.generate(username)
      AvatarGenerator.generate(username)
    else
      flash[:alert] = "Unable to find Instagram Account"
      return false
    end
  end

  private

  def user_params
    # params.require(:user).permit(:username, :first_name, :last_name, :email, :password, :password_confirmation)
    params.permit(:username, :first_name, :last_name, :email, :whatsapp_number, :password, :password_confirmation, :instagram_account)
  end
end
