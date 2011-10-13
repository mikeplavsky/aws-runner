#!/usr/bin/ruby

path = File.join File.dirname( __FILE__ )
$LOAD_PATH.push path

require "right_aws"
require 'core'

run do |ec2, image_id|

  instance = ec2.launch_instances(
  
    image_id, 
  
    :group_ids => "default",
    :key_name => "webserver",
    :instance_type => "t1.micro" 

  )[0]

  id = instance[:aws_instance_id]  

end
