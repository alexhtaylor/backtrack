class MapController < ApplicationController

  # require_relative '../../lib/avatar-scraper'

  def show
    # Loading location data from ip address as backup
    ip_address = Net::HTTP.get(URI("https://api.ipify.org?format=json"))
    ip_address = JSON.parse(ip_address)["ip"]
    current_location = Geocoder.search(ip_address).first || Geocoder.search('New York, NY').first
    @latitude_from_ip = current_location.latitude
    @longitude_from_ip = current_location.longitude
    @friend_ids_array = User.joins("INNER JOIN friendships ON friendships.user_id = users.id OR friendships.friend_id = users.id")
    .where('friendships.user_id = ? OR friendships.friend_id = ?', current_user.id, current_user.id)
    .where.not(id: current_user.id).distinct.pluck(:id)
    @friend_locations = Location.where(user_id: @friend_ids_array, current_location: true)
    @friends = User.where(id: @friend_ids_array.to_a)
    @friends_by_id = {}
    @friends.each do |friend|
      @friends_by_id[friend.id] = friend
    end
  end

  def request_friend
    # user is the user who will receive the request
    user = User.find_by(username: params[:username])
    # friend_ids_array = User.joins("INNER JOIN friendships ON friendships.user_id = users.id OR friendships.friend_id = users.id").where('friendships.user_id = ? OR friendships.friend_id = ?', current_user.id, current_user.id).where.not(id: current_user.id).distinct.pluck(:id)
    friend_ids_array = params[:friend_ids_array].map { |str| str.to_i }
    puts "FRIEND IDS ARRAY: #{friend_ids_array}"
    puts user.id
    if user && !friend_ids_array.include?(user.id) && !user.pending_request_ids.include?(current_user.id) && !current_user.pending_request_ids.include?(user.id)
      puts "USER IS TRUE and not already friends, or already pending to become friends"

      if user.pending_request_ids? && !user.pending_request_ids.include?(current_user.id) && !friend_ids_array.include?(user.id) && user.id != current_user.id && !current_user.pending_request_ids&.include?(user.id)
        puts "EXISTING ARRAY BEING ADDED TO"
        user.pending_request_ids << current_user.id
        user.save
      elsif !user.pending_request_ids? && !friend_ids_array&.include?(user.id) && user.id != current_user.id && !current_user.pending_request_ids&.include?(user.id)
        puts "NEW REQUEST ARRAY CREATED"
        user.pending_request_ids = [current_user.id]
        user.save
      end
      puts "NOW REDIRECTING"
      redirect_to map_path(params[:id])
      flash[:success] = 'Request sent successfully.'
    elsif user && friend_ids_array.include?(user.id) && !user.pending_request_ids.include?(current_user.id) && !current_user.pending_request_ids.include?(user.id)
      redirect_to map_path(params[:id])
      flash[:error] = "You are already friends with #{user.username}."
    elsif user && !friend_ids_array.include?(user.id) && user.pending_request_ids.include?(current_user.id) && !current_user.pending_request_ids.include?(user.id)
      redirect_to map_path(params[:id])
      flash[:error] = "Friend request to #{user.username} already pending"
    elsif user && !friend_ids_array.include?(user.id) && !user.pending_request_ids.include?(current_user.id) && current_user.pending_request_ids.include?(user.id)
      redirect_to map_path(params[:id])
      flash[:error] = "You already have a request from #{user.username}"
    else
      redirect_to map_path(params[:id])
      flash[:error] = 'Unable to find user.'
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
