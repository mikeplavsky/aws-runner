#!/usr/bin/ruby

require "right_aws"

if ARGV.length < 2
  puts 'runner.rb user repository'
  exit
end

user = ARGV[0]
repo = ARGV[1]

ec2 = RightAws::Ec2.new "AKIAJOJJD4ZFTSFFHHEQ", "P8QA2TdZv1tEBlBc6qDxKLIUytg0pNapHb+ECvkf"

require "./utils.rb"
create_sc_group ec2, user

image_id = ec2.describe_images(:filters => {'is-public' => false, 'name' => 'code-review-new'})[0][:aws_id]
puts "Found code-review-new image #{image_id}"

spot = ec2.request_spot_instances :image_id => image_id, :spot_price => 1, :instance_type => "m1.small", :key_name => "webserver", :groups => [user]

while true do

  request = ec2.describe_spot_instance_requests( :filters => { "spot-instance-request-id" => spot[0][:spot_instance_request_id]})[0]
  print "Spot Request #{request[:spot_instance_request_id]}, state #{request[:state]}\n"

  if request[:state] == 'active' 
    
    id = request[:instance_id]
    print "Instance started #{id}.\n"
    
    ec2.create_tags id, { "Name" => user }
    run_on_instance ec2, id, repo, user

    puts "Done"
    break

  end  

  sleep 60

end
