#!/usr/bin/ruby

path = File.join File.dirname( __FILE__ )
$LOAD_PATH.push path

require "right_aws"
require 'core'

load_cfg
config_logger

run do |ec2, image_id|

  instance = ec2.launch_instances(
  
    image_id, 
  
    :group_ids => @cfg['group-id'],
    :key_name => @cfg['key-name'],
    :instance_type => @cfg['instance-type']

  )[0]

  id = instance[:aws_instance_id]  

end
