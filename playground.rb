# require 'rest_client'
# require 'json'

#     api_url ="https://www.page2api.com/api/v1/scrape"
#     payload = {
#       api_key: '8e21d42abc80db79776fe0f1b2b60347eea6ed22',
#       url: "https://www.instagram.com/nasa",
#       parse: {
#         name: "header h2 >> text",
#         pic: "header img >> src",
#         following: "header ul li:nth-of-type(3) div span >> text",
#       },
#       premium_proxy: "us",
#       real_browser: true,
#       scenario: [
#         { execute_js: "for (const a of document.querySelectorAll('div[role=dialog] button')) { if (a.textContent.includes('essential cookies')) { a.click() }}" },
#         { wait_for: "header h2" },
#         { execute: "parse" }
#       ]
#     }

#     puts "about to send request"
#     response = RestClient::Request.execute(
#       method: :post,
#       payload: payload.to_json,
#       url: api_url,
#       headers: { "Content-type" => "application/json" },
#     ).body
#     puts "request sent"

#     profile_pic_src = JSON.parse(response)["result"]["pic"]

#     result = JSON.parse(response)

#     # print(profile_pic_src)

#     print(result)


require 'httparty'
require 'nokogiri'

# Make an HTTP request to download the webpage.
response = HTTParty.get("https://www.instagram.com/#{current_user.username}")

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


require 'open-uri'
require 'fileutils'

# Define the destination directory within app/assets/images
destination_directory = 'app/assets/images/'

# Define a file name for the downloaded image
local_file_name = "#{current_user.username}.jpg"

user_agent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36'

# Use open-uri to download the image and save it locally
URI.open(profile_pic_src, 'rb', 'User-Agent' => user_agent) do |file|
  File.open(local_file_name, 'wb') do |output_file|
    output_file.write(file.read)
  end
end

# Move the downloaded image to the destination directory
FileUtils.mv(local_file_name, File.join(destination_directory, local_file_name))

puts "Image downloaded and saved as #{File.join(destination_directory, local_file_name)}"


# require 'nokogiri'
# require 'open-uri'

# url = 'https://www.instagram.com/nasa/following'
# webpage = URI.open(url)
# doc = Nokogiri::HTML(webpage)

# # Define your complex CSS selector
# css_selector = 'span._aacl._aaco._aacw._aacx._aad7._aade'

# # Find the element using the CSS selector
# selected_element = doc.at_css(css_selector)

# # Extract and print the text content of the selected element
# if selected_element
#   puts "Text content found using the selector:"
#   puts selected_element.text
# else
#   puts "Element not found with the specified selector."
# end

# links = doc.css('a').map { |link| link['href'] }

# links.each do |link|
#   puts link
# end



# # Define your complex CSS selector
# css_selector = 'span'

# # Find the element using the CSS selector
# selected_element = document.at_css(css_selector)

# # Extract and print the text content of the selected element
# if selected_element
#   puts "Text content found using the selector:"
#   puts selected_element
# else
#   puts "Element not found with the specified selector."
# end


# "props":{"id":"528817151","profile_pic_url":"https:\/\/scontent.cdninstagram.com\/v\/t51.2885-19\/29090066_159271188110124_1152068159029641216_n.jpg?stp=dst-jpg_s200x200&_nc_cat=1&ccb=1-7&_nc_sid=8ae9d6&_nc_ohc=QlBbFge_v_QAX_dCTiC&_nc_ht=scontent.cdninstagram.com&oh=00_AfAh1UbaKsCI3iRJAW1MYy3IZkclbqrq1V4tGlfjQlJvvQ&oe=650E2A69","show_suggested_profiles":true,"page_logging":{"name":"profilePage","params":{"page_id":"profilePage_528817151","profile_id":"528817151","sub_path":"following"}},"qr":false,"polaris_preload":{"gated":{"expose":false,"preloaderID":"4883009247239155072","request":{"method":"GET","url":"\/api\/v1\/web\/get_ruling_for_content\/","params":{"query":{"content_type":"PROFILE","target_id":"528817151"}}},"preloadEnabledOnInit":false,"preloadEnabledOnNav":false},"profile":{"expose":false,"preloaderID":"7477946870923487818","request":{"method":"GET","url":"\/api\/v1\/users\/web_profile_info\/","params":{"query":{"username":"nasa"}}},"preloadEnabledOnInit":false,"preloadEnabledOnNav":false},"timeline":{"expose":false,"preloaderID":"8185276906298375591","request":{"method":"GET","url":"\/api\/v1\/feed\/user\/{username}\/username\/","params":{"path":{"username":"nasa"},"query":{"count":12}}},"preloadEnabledOnInit":false,"preloadEnabledOnNav":false},"profile_extras":{"expose":false,"preloaderID":"4659342925501596535","request":{"method":"GET","url":"\/graphql\/query\/","params":{"query":{"query_hash":"d4d88dc1500312af6f937f7b804c68c3","user_id":"528817151","include_chaining":false,"include_reel":true,"include_suggested_users":false,"include_logged_out_extras":true,"include_live_status":false,"include_highlight_reels":true}}},"preloadEnabledOnInit":false,"preloadEnabledOnNav":false}},"enable_seo_crawling_pool":false},"entryPoint":{"__dr":"PolarisProfileRoot.entrypoint"}
