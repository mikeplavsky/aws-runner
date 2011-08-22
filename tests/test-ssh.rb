ip = "10.254.139.214"

print "connecting to #{ip}\n"

require 'net/ssh'
require 'net/scp'
require '../core.rb'

require "logger"
@logger = Logger.new STDOUT

Net::SSH.start ip, 'ubuntu', :keys => ['/home/ubuntu/.ssh/webserver.pem'], :keys_only => true  do |ssh|
  download ssh, "hunter", "python.duplication.html"
end


