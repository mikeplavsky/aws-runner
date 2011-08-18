def create_sc_group ec2, name

  begin
    ec2.delete_security_group name
  rescue RightAws::AwsError => err
    puts err
  end

  ec2.create_security_group name

  require 'socket'

  ip = IPSocket.getaddress Socket.gethostname()
  ec2.authorize_security_group_IP_ingress name, 22, 22, 'tcp', "#{ip}/32"

end

def wait_ssh ip

  while true

    begin
      
      require 'socket'
      s = TCPSocket.open ip, 22

      break

    rescue
      
      puts "Waiting for ssh on #{ip}"
      sleep 10

    end

  end
end

def run_on_instance ec2, id, repo, user, script = "finder.sh"

  instance = ec2.describe_instances(:filters => {"instance-id" => id })[0]
  ip = instance[:private_ip_address]

  puts "Instance IP Address #{ip}"
  wait_ssh ip

  identity = '/home/ubuntu/.ssh/webserver.pem'
  puts `scp -i #{identity} "/home/ubuntu/codereview/#{script}" ubuntu@#{ip}:/home/ubuntu/codereview/`

  require 'net/ssh' 

  Net::SSH.start ip, "ubuntu", :keys => [identity], :keys_only => true  do |ssh|  

    ssh.exec! "/home/ubuntu/codereview/#{script} #{repo}" do |channel, stream, data|
      puts data
    end

  end

  copy_results identity, ip, user

end

def copy_results identiy, ip, user
  
  puts `scp -i #{identity} ubuntu@#{ip}:/home/ubuntu/python.duplication.html /home/#{user}/`
  puts `scp -i #{identity} ubuntu@#{ip}:/home/ubuntu/js.duplication.html /home/#{user}/`

end

