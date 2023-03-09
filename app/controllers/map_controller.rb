class MapController < ApplicationController
  def show
    # ip_address = Net::HTTP.get(URI("https://api.ipify.org?format=json"))
    # ip_address = JSON.parse(ip_address)["ip"]
    # current_location = Geocoder.search(ip_address).first || Geocoder.search('New York, NY').first
    # @latitude = current_location.latitude
    # @longitude = current_location.longitude

    @latitude = params[:latitude]
    @longitude = params[:longitude]
    # render 'show', locals: { latitude: @latitude, longitude: @longitude }
    puts "finally working latitude??? #{@latitude}"
  end
end
