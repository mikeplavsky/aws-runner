require "right_aws"

ec2 = RightAws::Ec2.new "AKIAJOJJD4ZFTSFFHHEQ", "P8QA2TdZv1tEBlBc6qDxKLIUytg0pNapHb+ECvkf"

spots = ec2.describe_spot_instance_requests :filters => {"spot-instance-request-id" => "sir-a57da614"}
print spots
