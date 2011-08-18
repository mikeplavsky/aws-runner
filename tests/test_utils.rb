require "right_aws"
ec2 = RightAws::Ec2.new "AKIAJOJJD4ZFTSFFHHEQ", "P8QA2TdZv1tEBlBc6qDxKLIUytg0pNapHb+ECvkf"

require "../utils.rb"

#create_sc_group ec2, "wizard"
run_on_instance ec2, "i-9bf8a2fa", "git@github.com:grigoryvasiliev/SASP.git"
