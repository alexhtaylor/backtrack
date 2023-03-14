class LocationsController < ApplicationController

  def show
    session[:latitude] = params[:latitude]
    session[:longitude] = params[:longitude]
  end

  def create
    update
    @location = current_user.locations.new(location_params)
    @location.latitude = session[:latitude]
    @location.longitude = session[:longitude]
    # Testing
    # @location.latitude = 23
    # @location.longitude = 74
    #
    @location.datetime = DateTime.current

    if @location.save
      flash[:success] = "Location pinned!"
      puts "Location pinned!"
      redirect_to map_path
    else
      flash[:error] = "Failed to pin location."
      puts "Failed to pin location."
      redirect_to map_path
    end
  end

  def update
    @all_locations = current_user.locations
    @all_locations.each do |location|
      location.current_location = false
      location.save
    end
  end

  def toggle_location_visibility
    @location = current_user.locations.find_by(current_location: true)
    @location.update(visible: !@location.visible)
  end

  private

  def location_params
    params.require(:location).permit(:latitude, :longitude, :current_location, :visible)
  end
end
