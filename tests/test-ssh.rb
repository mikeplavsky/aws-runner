ip = ARGV[0]
repo = ARGV[1]

print "connecting to #{ip}\n"

require 'net/ssh'

Net::SSH.start ip, 'ubuntu', :keys => ['/home/ubuntu/.ssh/id_rsa'], :keys_only => true  do |ssh|
  
  ssh.exec! "/home/ubuntu/finder.sh #{repo}" do |channel, stream, data|
    puts data
  end 

end


