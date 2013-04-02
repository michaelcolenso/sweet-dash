require 'instagram'

# Instagram Client ID from http://instagram.com/developer
Instagram.configure do |config|
  config.client_id = 'ac88ba70b906488886f1451055ab8ee2'
end

# Latitude, Longitude for location
instadash_location_lat = '34.097430'
instadash_location_long = '-118.357979'

SCHEDULER.every '1m', :first_in => 0 do |job|
  photos = Instagram.media_search(instadash_location_lat,instadash_location_long)
  if photos
    photos.map! do |photo|
      { photo: "#{photo.images.standard_resolution.url}", user: "#{photo.user.username}", user_pic: "#{photo.user.profile_picture}", tags: "#{photo.tags}", caption: "#{photo.caption}" }
    end    
  end
  send_event('instadash', photos: photos)
end
