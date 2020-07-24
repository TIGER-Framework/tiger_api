
module DockersHelper
  def get_images(docker_obj)
    # curl -k https://10.0.2.15:2376/images/json --cert ~/.docker_obj/cert.pem --key ~/.docker_obj/key.pem --cacert ~/.docker_obj/ca.pem
    return http_req(docker_obj.docker_host_fqdn,docker_obj.docker_host_api_key,docker_obj.docker_host_api_cert,'/images/json')
  end
  def schedule_test(test_obj,docker_obj,influxdb_obj)
    docker_image_name='tiger_jmeter'
    docker_container_name='tiger_jmeter_'+Time.now.to_f.to_s.gsub('.','')
   

    params={
      "Image": docker_image_name,
      "User": test_obj.user_id,
      "Env": [
        "tests_repo=#{test_obj.git_repo_url}",
        #"test_type=#{test_obj.test_type}",
        "test_type=sample",
        "current_build_number=1",
        "project_id=TIGER",
        "env_type=dev",
        "lg_id=lg_1",
        "influx_protocol=#{influxdb_obj.protocol}",
        "influx_host=#{influxdb_obj.host}",
        "influx_port=#{influxdb_obj.port}",
        "influx_db=#{influxdb_obj.db_name}",
        "influx_username=#{influxdb_obj.username}",
        "influx_password=#{influxdb_obj.password}"
        ]
    }
    http_req(docker_obj.docker_host_fqdn,docker_obj.docker_host_api_key,docker_obj.docker_host_api_cert,'/containers/create?name='+docker_container_name,params)
    params={}
    http_req(docker_obj.docker_host_fqdn,docker_obj.docker_host_api_key,docker_obj.docker_host_api_cert,'/containers/'+docker_container_name+'/start',params)
    
    return http_req(docker_obj.docker_host_fqdn,docker_obj.docker_host_api_key,docker_obj.docker_host_api_cert,'/containers/'+docker_container_name+'/json')
  end
  def http_req(docker_host_fqdn,docker_host_api_key,docker_host_api_cert,uri,params='')
    require 'net/https'
    https = Net::HTTP.new(docker_host_fqdn, 2376)
    https.use_ssl = true
    https.cert = OpenSSL::X509::Certificate.new(docker_host_api_cert) #File.read(Rails.root.join('docker_certs','cert.pem')))
    https.key = OpenSSL::PKey::RSA.new(docker_host_api_key) #Rails.root.join('docker_certs','key.pem')))
    https.verify_mode = OpenSSL::SSL::VERIFY_NONE
    https.read_timeout = 120
    https.start do |https|
      if params.is_a?(Hash)
        request = Net::HTTP::Post.new(uri,{"Content-Type": "application/json"})
        request.body=(params).to_json
      else
        request = Net::HTTP::Get.new(uri)
      end
      response = https.request(request)
#      response.value
      return response.body
    
    end
  end
end
