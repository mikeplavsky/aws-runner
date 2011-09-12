def info str
  @logger.info str
end

def get_ec2

  require "yaml"

  @cfg = YAML.load( File.read( File.join File.dirname( __FILE__ ), "config.yml" ))  
  ec2 = RightAws::Ec2.new @cfg["access_key_id"], @cfg["secret_access_key"], :logger => @logger
  
end

def config_logger user

  require 'logger'

  fn = "/home/ubuntu/#{user}/log.txt"
  `rm #{fn}`

  @logger = Logger.new fn 
  @logger.level = Logger::DEBUG
  
end

def run user, repo

    config_logger user
    ec2 = get_ec2

    create_sc_group ec2, user

    image_id = ec2.describe_images(:filters => {'is-public' => false, 'name' => 'code-review-new'})[0][:aws_id]
    info "Found code-review-new image #{image_id}"

    id = yield ec2, image_id, user
    
    wait_for_ip ec2, id
    ec2.create_tags id, { "Name" => user }
    run_on_instance ec2, id, repo, user

    info "done"

  rescue => e
    
    info e
  
end

def wait_for_spot_instance ec2, spot_request_id
  
  while true do

    request = ec2.describe_spot_instance_requests( :filters => { "spot-instance-request-id" => spot_request_id})[0]
    info "Spot Request #{spot_request_id}, state #{request[:state]}"

    if request[:state] == 'active' 
      
      id = request[:instance_id]
      info "Instance started #{id}."

      return id

    end  

    sleep 60

  end
  
end

def create_sc_group ec2, name

  begin
    ec2.delete_security_group name
  rescue RightAws::AwsError => err
    info err
  end

  ec2.create_security_group name

  require 'socket'

  ip = IPSocket.getaddress Socket.gethostname()
  ec2.authorize_security_group_IP_ingress name, 22, 22, 'tcp', "#{ip}/32"

end

def wait_ssh ip

  raise "Nil ip" unless ip

  while true

    res = `ssh -i #{identity} ubuntu@#{ip}  uptime`
    info "ssh on #{ip}: #{res}"

    res =~ /load average: (\d.\d\d)/
    
    if not $1 or Float($1) > 0.1
      sleep 10          
    else 

      info "ssh is open on #{ip}"
      break

    end

  end
end

def get_ip ec2, id
  return ec2.describe_instances(id)[0][:private_ip_address] 
end

def identity
  @cfg["ssh_identity"]
end

def run_on_instance ec2, id, repo, user, script = "finder.sh"

  ip = get_ip ec2, id

  info "Instance IP Address #{ip}"
  wait_ssh ip

  require 'net/ssh' 
  require 'net/scp' 

  Net::SSH.start ip, "ubuntu", :keys => [identity], :keys_only => true do |ssh|  

    info "Uploading #{script} to #{ip}"
    ssh.scp.upload! "/home/ubuntu/codereview/#{script}", "/home/ubuntu/codereview"

    info "Starting #{script} on #{ip}"
    ssh.exec! "~/codereview/#{script} #{repo}" 

    download ssh, user, "python.duplication.html"
    download ssh, user, "js.duplication.html"


  end

end

def download ssh, user, file 

  info "Downloading #{file}"
  ssh.scp.download! "/home/ubuntu/#{file}", "/home/ubuntu/#{user}"

  dups  = `grep duplicates /home/ubuntu/#{user}/#{file}`.split[6].gsub /[()]/, ""
  errs  = `grep "Error: can't parse" /home/ubuntu/#{user}/#{file}` != ""

  msg = "#{user} #{file}: #{dups}, Errors: #{errs}"

  info msg 
  puts msg

end

def wait_for_ip ec2, id

  while true
      
    ip = get_ip ec2, id

    if ip
      info "#{id} got ip #{ip}"
      break
    end

    info "#{id} ip address is not yet available"
    sleep 10

  end
end  
