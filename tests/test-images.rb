require "right_aws"
ec2 = RightAws::Ec2.new "AKIAJOJJD4ZFTSFFHHEQ", "P8QA2TdZv1tEBlBc6qDxKLIUytg0pNapHb+ECvkf"

image = ec2.describe_images(:filters => {'is-public' => false, 'name' => 'code-review'})[0]
puts image[:aws_id]
