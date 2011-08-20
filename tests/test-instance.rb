#require "right_aws"
#ec2 = RightAws::Ec2.new "AKIAJOJJD4ZFTSFFHHEQ", "P8QA2TdZv1tEBlBc6qDxKLIUytg0pNapHb+ECvkf"

require '../utils.rb'
#require 'logger'
#Utils::logger = Logger.new STDOUT

include Utils

#run_on_instance ec2, "i-8f0f2cee", "git://github.com/rightscale/right_aws.git", "hunter"
copy_results "10.70.70.176", "hunter"
