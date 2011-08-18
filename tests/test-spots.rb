require "right_aws"

ec2 = RightAws::Ec2.new "AKIAJOJJD4ZFTSFFHHEQ", "P8QA2TdZv1tEBlBc6qDxKLIUytg0pNapHb+ECvkf"

request = ec2.describe_spot_instance_requests( :filters => {"spot-instance-request-id" => "sir-0e179c12"})[0]
puts request

id = request[:instance_id]
puts "Instance started #{id}.\n"

instance = ec2.describe_instances( :filters => {"instance-id" => id })[0]

ip =  instance[:private_ip_address]
puts "Instance IP Address #{ip}"

puts `ssh -i /home/ubuntu/.ssh/webserver.pem ubuntu@#{ip} ls`
puts `scp -i /home/ubuntu/.ssh/webserver.pem ubuntu@#{ip}:/home/ubuntu/sinatra.test/*.rb /home/ubuntu/ `
