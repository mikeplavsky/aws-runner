def info str
  @logger.info str
end

def load_cfg

  require "yaml"
  @cfg = YAML.load( File.read( "./config.yml" ) )  

end

def get_ec2
  ec2 = RightAws::Ec2.new @cfg["access_key_id"], @cfg["secret_access_key"], :logger => @logger
end

def config_logger 

  require 'logger'
  fn = "./log.txt"

  @logger = Logger.new fn 
  @logger.level = Logger::DEBUG
  
end

def repo_name repo
  /:(.*).git/.match( repo )[1].sub '/', '@'
end

def run 

    ec2 = get_ec2
    repo = @cfg["repo"]

    where = repo_name(repo)

    image_id = ec2.describe_images(:filters => {'is-public' => false, 'name' => @cfg['ami-name']})[0][:aws_id]
    info "Found #{@cfg['ami-name']} image #{image_id}"

    id = yield ec2, image_id
    
    wait_for_ip ec2, id
    ec2.create_tags id, { "Name" => where}
    run_on_instance ec2, id, repo 

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

def run_on_instance ec2, id, repo 

  where = repo_name repo

  ip = get_ip ec2, id

  info "Instance IP Address #{ip}"
  wait_ssh ip

  require 'net/ssh' 
  require 'net/scp' 

  Net::SSH.start ip, "ubuntu", :keys => [identity], :keys_only => true do |ssh|  

    info "Cloning #{repo} on #{ip}"
    ssh.exec! "git clone #{repo} /tmp/#{where}" 

    info "Uploading ./config.yml to #{ip}"
    ssh.scp.upload! "./config.yml", "/tmp/#{where}"

    info "Executing run.sh script on #{ip}"
    ssh.exec! "cd /tmp/#{where}; ruby ./run.rb"

  end

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
