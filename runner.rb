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

  instance = ec2.launch_instances( image_id, :group_ids => sec_group, :key_name => "webserver", :instance_type => "m1.small" )[0]
  id = instance[:aws_instance_id]  

end
