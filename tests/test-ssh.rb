ip = "10.195.199.182"

puts "connecting to #{ip}\n"

require 'net/ssh'

Net::SSH.start ip, 'ubuntu', :keys => ['/home/ubuntu/.ssh/webserver.pem'], :keys_only => true  do |ssh|
  ssh.exec "sleep 10; touch super.log"
end

puts "All done"
