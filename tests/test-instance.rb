require "right_aws"
ec2 = RightAws::Ec2.new "AKIAJOJJD4ZFTSFFHHEQ", "P8QA2TdZv1tEBlBc6qDxKLIUytg0pNapHb+ECvkf"

ec2.create_tags "i-11ca9970", { "Name" => "solomon" }
