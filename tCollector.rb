
unless ARGV.size == 1
  print "Usage: 
    #{__FILE__} twitter_user\n"
  exit
end

twitter_user = ARGV.first

timeline = %x( t timeline #{ twitter_user } -n 1000000 --csv ).split('\n')

File.open(twitter_user, 'w') do |file| 
  timeline.each {|t| file.write("#{ t }\n")} 
end

