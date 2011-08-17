require "right_aws"
ec2 = RightAws::Ec2.new "AKIAJOJJD4ZFTSFFHHEQ", "P8QA2TdZv1tEBlBc6qDxKLIUytg0pNapHb+ECvkf"

def create_sc_group ec2, name

  begin
    ec2.delete_security_group name
  rescue RightAws::AwsError => err
    puts err
  end

  ec2.create_security_group name

  require 'socket'

  ip = IPSocket.getaddress Socket.gethostname()
  ec2.authorize_security_group_IP_ingress name, 22, 22, 'tcp', "#{ip}/32"

end

create_group ec2, "solomon"
