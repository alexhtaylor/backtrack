require 'httparty'
require 'nokogiri'
require 'open-uri'
require 'fileutils'

class AvatarGenerator
  def self.generate(username)

    # Make an HTTP request to download the webpage.
    response = HTTParty.get("https://www.instagram.com/#{username}")

    # Parse the HTML document.
    document = Nokogiri::HTML(response.body)

    # Find the JavaScript data that contains "props"
    script_text = document.search('script').map(&:text).find { |text| text.include?('props') }


    # puts "script text #{script_text}"
    if script_text
      # Extract the JavaScript object containing "props"
      js_object = script_text.match(/"props":\s*({[^}]+})/)

      # puts "js_object #{js_object}"

      if js_object
        # Extract the JSON data and clean it up
        json_data = "#{js_object[1].gsub(/\\/, '')}}}" # Remove escape characters

        # Parse the cleaned JSON data
        require 'json'
        begin
          props_object = JSON.parse(json_data)
          profile_pic_src = props_object["profile_pic_url"]

          # Now you can work with the "props" object
          puts "Found 'props' object with id: #{props_object['id']}"
          puts "profile-pic url: #{profile_pic_src}"
        rescue JSON::ParserError => e
          puts "Error parsing JSON data: #{e.message}"
        end
      else
        puts "No 'props' object found in the JavaScript data."
      end
    else
      puts "No JavaScript data containing 'props' found in the document."
    end

    # Define the destination directory within app/assets/images
    destination_directory = 'app/assets/images/'

    # Define a file name for the downloaded image
    local_file_name = "#{username}.jpg"

    user_agent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36'

    # Use open-uri to download the image and save it locally
    URI.open(profile_pic_src, 'rb', 'User-Agent' => user_agent) do |file|
      File.open(local_file_name, 'wb') do |output_file|
        output_file.write(file.read)
      end
    end

    # Move the downloaded image to the destination directory
    FileUtils.cp(local_file_name, File.join(destination_directory, local_file_name))

    "/assets/#{username}.jpg"
  end
end
