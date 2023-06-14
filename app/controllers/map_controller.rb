class MapController < ApplicationController

  require_relative '../../lib/avatar-scraper'

  def show
  end

  def request_friend
    user = User.find_by(username: params[:username])
    friend_ids_array = User.joins("INNER JOIN friendships ON friendships.user_id = users.id OR friendships.friend_id = users.id").where('friendships.user_id = ? OR friendships.friend_id = ?', current_user.id, current_user.id).where.not(id: current_user.id).distinct.pluck(:id)
    puts "FRIEND IDS ARRAY: #{friend_ids_array}"
    if user
      puts "USER IS TRUE"

      if user.pending_request_ids && !user.pending_request_ids.include?(current_user.id) && !friend_ids_array.include?(user.id) && user.id != current_user.id && !current_user.pending_request_ids&.include?(user.id)
        puts "EXISTING ARRAY BEING ADDED TO"
        user.pending_request_ids << current_user.id
        user.save
      elsif !user.pending_request_ids && !friend_ids_array.include?(user.id) && user.id != current_user.id && !current_user.pending_request_ids&.include?(user.id)
        puts "NEW REQUEST ARRAY CREATED"
        user.pending_request_ids = [current_user.id]
        user.save
      end
      puts "NOW REDIRECTING"
      redirect_to map_path(params[:id]), notice: "Friend request sent successfully."
    else
      redirect_to map_path(params[:id]), alert: "User not found."
    end
  end

  def accept_friend
    puts "INSIDE ACCEPT FRIEND"
    user = User.find_by(id: params[:user_id])
    current_user.friendships.create(friend: user)
    puts "DELETING USER ID FROM REQUESTS"
    current_user.pending_request_ids.delete(params[:user_id].to_i)
    puts "RELOADING PAGE"
    current_user.save
    redirect_to map_path(params[:id])
  end

  def reject_friend
    puts "INSIDE REJECT FRIEND"
    puts current_user.username
    puts params[:user_id].class
    puts current_user.pending_request_ids[0].class
    current_user.pending_request_ids.delete(params[:user_id].to_i)
    current_user.save
    redirect_to map_path(params[:id])
  end
end
