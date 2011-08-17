require "right_aws"

ec2 = RightAws::Ec2.new "AKIAJOJJD4ZFTSFFHHEQ", "P8QA2TdZv1tEBlBc6qDxKLIUytg0pNapHb+ECvkf"
spot = ec2.request_spot_instances :image_id => "ami-3977b150", :spot_price => 1, :instance_type => "m1.small", :key_name => "webserver", :groups => ["default"]

while true do

  request = ec2.describe_spot_instance_requests( :filters => { "spot-instance-request-id" => spot[0][:spot_instance_request_id]})[0]
  print "Spot Request #{request[:spot_instance_request_id]}, state #{request[:state]}\n"

  if request[:state] == 'active' 
    print "Instance started.\n"
    break
  end  

  sleep 10

end
