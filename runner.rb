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

instance = ec2.launch_instances( image_id, :group_ids => user, :key_name => "webserver", :instance_type => "t1.micro" )[0]

id = instance[:aws_instance_id]  
wait_for_ip ec2, id

ec2.create_tags id, { "Name" => user }

run_on_instance ec2, id, repo, user
puts "Done"
