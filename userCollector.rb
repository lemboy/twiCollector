require 'rubygems'
require 'bundler/setup'
require 'twitter'
require './config'

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = TWITTER_API_KEY      
  config.consumer_secret     = TWITTER_API_SECRET   
  config.access_token        = TWITTER_TOKEN        
  config.access_token_secret = TWITTER_TOKEN_SECRET 
end

unless ARGV.size == 1
  print "Usage: 
    #{__FILE__} twitter_user\n"
  exit
end

twitter_user = ARGV.first

begin
  timeline = client.user_timeline(twitter_user, {include_rts: false, count: 200})
rescue Twitter::Error => e
  print "Twitter error: #{e.message}\n"
  exit
end

file_name = File.join("data", twitter_user) 

File.open(file_name, 'w') do |file| 
  timeline.each {|t| file.write("#{t.attrs[:created_at]} #{t.attrs[:text]}\n")} 
end

