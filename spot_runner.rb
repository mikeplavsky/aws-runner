#!/usr/bin/ruby

require "right_aws"

if ARGV.length < 2
  puts 'runner.rb user repository'
  exit
end

user = ARGV[0]
repo = ARGV[1]

require './core.rb'

run user, repo do |ec2, image_id, sec_group|

  spot = ec2.request_spot_instances :image_id => image_id, :spot_price => 1, :instance_type => "m1.small", :key_name => "webserver", :groups => [sec_group]
  id = wait_for_spot_instance ec2, spot[0][:spot_instance_request_id] 

end


