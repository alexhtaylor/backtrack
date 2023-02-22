class PagesController < ApplicationController
  def welcome
    @user = current_user
  end
end
