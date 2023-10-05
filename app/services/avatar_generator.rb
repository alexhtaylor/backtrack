require 'httparty'
require 'nokogiri'
require 'open-uri'
require 'fileutils'
require 'tempfile'
require "google/cloud/storage"

class AvatarGenerator

  def self.generate(username)
    # Make an HTTP request to download the webpage.
    begin
      response = HTTParty.get("https://www.instagram.com/#{username}")

      # Check the response status code
      if response.success?
        # Process the successful response here
        document = Nokogiri::HTML(response.body)
      else
        return false
      end
    rescue StandardError => e
      # Handle other types of errors here if needed
      return false
    end

    script_text = document.search('script').map(&:text).find { |text| text.include?('props') }

    if script_text
      # Extract the JavaScript object containing "props"
      js_object = script_text.match(/"props":\s*({[^}]+})/)

      if js_object
        # Extract the JSON data and clean it up
        json_data = "#{js_object[1].gsub(/\\/, '')}}}" # Remove escape characters

        # Parse the cleaned JSON data
        require 'json'
        begin
          props_object = JSON.parse(json_data)
          profile_pic_src = props_object["profile_pic_url"]
        rescue JSON::ParserError => e
          puts "Error parsing JSON data: #{e.message}"
        end
      else
        puts "No 'props' object found in the JavaScript data."
      end
    else
      puts "No JavaScript data containing 'props' found in the document."
    end

    # Use backticks to run the JavaScript file and pass the image URL
    if profile_pic_src
      puts 'about to trigger javascript'

      ENV['USERNAME'] = username
      ENV['SRC'] = profile_pic_src
      system("node app/assets/javascripts/avatarUpload.js")

      puts 'ruby generator file complete'

      "https://storage.cloud.google.com/backtrack-profile-images/#{username}.jpg"
    else
      "/assets/backpack-icon-large-#{rand(1..10)}.png"
    end
  end
end
