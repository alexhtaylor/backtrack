# require 'open-uri'

# def scrape_logo(url)
#   doc = Nokogiri::HTML(URI.open(url))

#   img_element = doc.css('img ._aadp')
#   img_src = img_element.attribute('src').value
#   img_src
# end

require 'selenium-webdriver'
require 'nokogiri'

def scrape_logo(url)
  # Configure Selenium to use Chrome
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless') # Run Chrome in headless mode (without GUI)
  driver = Selenium::WebDriver.for :chrome, options: options

  # Load the webpage and wait for it to fully render
  driver.get(url)
  sleep 1
  # wait = Selenium::WebDriver::Wait.new(timeout: 50) # Adjust the timeout as needed
  # wait.until { driver.execute_script('return document.readyState') == 'complete' }

  # Use Nokogiri to parse the HTML of the fully loaded page
  doc = Nokogiri::HTML(driver.page_source)

  # Scrape the image source
  img_element_length = doc.css('img').length
  img_element = doc.css('img').last
  img_src = img_element.attribute('src').value
  puts "heres img length #{img_element_length}"

  # Quit the Selenium driver
  driver.quit

  img_src
end



# require 'instagram-private-api'

# # Initialize the Instagram client

# client = InstagramPrivateAPI.client
# # username = 'zandertaylor'
# def scrape_logo(username)
#   # Define the username for which you want to retrieve the profile picture
#   # Search for the user by username
#   user = client.user_search(username).first

#   # Retrieve the user's profile picture URL
#   profile_picture_url = user.profile_pic_url

#   # Download the profile picture
#   File.open("#{username}_profile_picture.jpg", 'wb') do |file|
#     file.write(open(profile_picture_url).read)
#   end

#   puts "Profile picture saved as #{username}_profile_picture.jpg"
# end
