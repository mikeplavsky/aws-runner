require "right_aws"
require "../core.rb"

file = File.open( "test.txt", "w" ) {|f| f.flock( File::LOCK_SH ) } 

@logger = Logger.new file
@logger.level = Logger::DEBUG

ec2 = RightAws::Ec2.new "AKIAJOJJD4ZFTSFFHHEQ", "P8QA2TdZv1tEBlBc6qDxKLIUytg0pNapHb+ECvkf", :logger => @logger

while true do

  info "Done!"
  sleep 10

end

