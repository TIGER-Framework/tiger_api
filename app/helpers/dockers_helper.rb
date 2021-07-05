module DockersHelper

  def get_images(docker_obj)
    # curl -k https://10.0.2.15:2376/images/json --cert ~/.docker_obj/cert.pem --key ~/.docker_obj/key.pem --cacert ~/.docker_obj/ca.pem
    return http_req(docker_obj.docker_host_fqdn,docker_obj.docker_host_api_key,docker_obj.docker_host_api_cert,'/images/json')
  end

  def schedule_test(test_obj,docker_obj,influxdb_obj,schedule_params,start_params,container_name)

    Rails.logger.info "Scheduling docker container with the following params: #{schedule_params}"
    Rails.logger.info http_req(docker_obj.docker_host_fqdn,docker_obj.docker_host_api_key,docker_obj.docker_host_api_cert,'/containers/create?name='+container_name,schedule_params)

    Rails.logger.info "Starting the container"
    Rails.logger.info http_req(docker_obj.docker_host_fqdn,docker_obj.docker_host_api_key,docker_obj.docker_host_api_cert,'/containers/'+container_name+'/start',start_params)

    Rails.logger.info "Container status: "
    container_status= JSON.parse(http_req(docker_obj.docker_host_fqdn,docker_obj.docker_host_api_key,docker_obj.docker_host_api_cert,'/containers/'+container_name+'/json'))
    Rails.logger.info container_status

    container_status['Config']['Env'].each do |line|
      if /password/.match(line)
        line = line.gsub(/=.+/,'= *******')
      end
    end

    return container_status

  end

  def stop_container(running_test_obj,docker_obj)
    Rails.logger.info http_req(docker_obj.docker_host_fqdn,docker_obj.docker_host_api_key,docker_obj.docker_host_api_cert,"/containers/#{running_test_obj.container_name}/stop")
  end

  def http_req(docker_host_fqdn,docker_host_api_key,docker_host_api_cert,uri,req_params='')
    require 'net/https'
    https = Net::HTTP.new(docker_host_fqdn, 2376)
    https.use_ssl = true
    https.cert = OpenSSL::X509::Certificate.new(docker_host_api_cert) #File.read(Rails.root.join('docker_certs','cert.pem')))
    https.key = OpenSSL::PKey::RSA.new(docker_host_api_key) #Rails.root.join('docker_certs','key.pem')))
    https.verify_mode = OpenSSL::SSL::VERIFY_NONE
    https.read_timeout = 120
    https.start do |https|
      if req_params.is_a?(Hash)
        request = Net::HTTP::Post.new(uri,{"Content-Type": "application/json"})
        request.body=(req_params).to_json
      else
        request = Net::HTTP::Get.new(uri)
      end
      response = https.request(request)
#      response.value
      return response.body

    end
  end

end

