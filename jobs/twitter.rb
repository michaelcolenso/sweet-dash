#!/usr/bin/env ruby
require 'net/http'
require 'json'

search_term = URI::encode('@foobugs OR @ephigenia')

SCHEDULER.every '2m', :first_in => 0 do |job|
  http = Net::HTTP.new('search.twitter.com')
  response = http.request(Net::HTTP::Get.new("/search.json?q=#{search_term}"))
  if response.code != "200"
    puts "twitter search api error (status-code: #{response.code})\n#{response.body}"
  else 
    tweets = JSON.parse(response.body)["results"]
    if tweets
      tweets.map! do |tweet| 
        { name: tweet['from_user'], body: tweet['text'], avatar: tweet['profile_image_url_https'] }
      end
      send_event('twitter_mentions', comments: tweets)
    end
  end
end