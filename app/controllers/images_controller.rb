require 'open-uri'

class ImagesController < ApplicationController
  def show

    puts "Image SHOW IS RUNNING"
    image_url = params[:url]
    image_data = URI.open(URI.parse(image_url))

    send_data image_data, type: 'image/jpeg', disposition: 'inline'
  end
end
