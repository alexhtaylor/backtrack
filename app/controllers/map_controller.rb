class MapController < ApplicationController
  include Geocoder
  require 'json'
  require 'net/http'
  def show
    ip_address = Net::HTTP.get(URI("https://api.ipify.org?format=json"))
    ip_address = JSON.parse(ip_address)["ip"]
    current_location = Geocoder.search(ip_address).first || Geocoder.search('New York, NY').first
    @latitude = current_location.latitude
    @longitude = current_location.longitude
  end
end

# class MapController < ApplicationController
#   before_action :require_login

#   def index
#   end

#   private

#   def require_login
#     unless current_user
#       redirect_to login_path
#     end
#   end
# end
