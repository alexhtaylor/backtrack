class LocationsController < ApplicationController
  def create
    update
    @location = current_user.locations.new(location_params)
    # Testing
    # @location.latitude = 20
    # @location.longitude = 99
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
    # respond_to do |format|
    #   if @location.save
    #     flash[:success] = "Location pinned!"
    #     format.js # Render create.js.erb
    #   else
    #     flash[:error] = "Failed to pin location."
    #     format.js { render :create_error } # Render create_error.js.erb
    #   end
    # end
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

# class LocationsController < ApplicationController
#   def create
#     update
#     @location = current_user.locations.new(location_params)
#     @location.datetime = DateTime.current

#     if @location.save
#       flash[:success] = "Location pinned!"
#       # Call the `addMarker` function after location is saved
#       respond_to do |format|
#         format.html { redirect_to map_path }
#         format.js
#       end
#     else
#       flash[:error] = "Failed to pin location."
#       # redirect_to map_path
#     end
#   end

#   def update
#     @all_locations = current_user.locations
#     @all_locations.each do |location|
#       location.current_location = false
#       location.save
#     end
#   end

#   private

#   def location_params
#     params.require(:location).permit(:latitude, :longitude, :current_location, :visible)
#   end
# end
