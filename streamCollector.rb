require 'rubygems'
require 'bundler/setup'
require 'twitter'
require './config'

client = Twitter::Streaming::Client.new do |config|
  config.consumer_key        = TWITTER_API_KEY      
  config.consumer_secret     = TWITTER_API_SECRET   
  config.access_token        = TWITTER_TOKEN        
  config.access_token_secret = TWITTER_TOKEN_SECRET 
end

file_name = File.join('data', 'twit_stream') 

File.open(file_name, 'a') do |file| 
  begin
    client.sample do |object|
      file.write("#{object.created_at} : #{object.user.id} : #{object.text.gsub("\n",'')}") if object.is_a?(Twitter::Tweet) && object.lang.include?("en")
      print "#{ file.size } (#{ file.size/2**20 } Mb)\r"
    end
  rescue Twitter::Error => e
    print "Twitter error: #{e.message}\n"
    exit
  end
end
