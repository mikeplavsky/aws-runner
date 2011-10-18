#!/usr/bin/ruby

path = File.join File.dirname( __FILE__ )
$LOAD_PATH.push path

require "right_aws"
require 'core'

load_cfg
config_logger

run do |ec2, image_id|

  spot = ec2.request_spot_instances
    
    :image_id => image_id, 
    :spot_price => 1,
    :instance_type => @cfg['instance-type'], 
    :key_name => @cfg['key-name'],
    :groups => [@cfg['group-id']]

  id = wait_for_spot_instance ec2, spot[0][:spot_instance_request_id] 

end


