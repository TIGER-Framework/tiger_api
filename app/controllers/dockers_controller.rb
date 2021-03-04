class DockersController < ApplicationController

  def new
#    render plain: params[:host].inspect
  end


  def schedule_test

    @docker=Docker.find(params[:docker_host][:id])
    @test_obj=Test.find(params[:id])
    @influxdb_obj=Influxdb.find(params[:influxdb_adapter_id])

    @container_name=params[:docker_image_name].gsub(/:|\//,'_')+'_'+Time.now.to_f.to_s.gsub('.','')
    @schedule_params={
      "HostConfig": {
        "Memory": @test_obj.ram * 1000000, # Memory is using bytes
        "CpusetCpus": @test_obj.cpu_cores.to_s,
        "AutoRemove": true
      },
      "Image": params[:docker_image_name],
      "User": @test_obj.user_id,
      "Env": [
        "tests_repo=#{@test_obj.git_repo_url}",
        "test_type=#{@test_obj.test_type}", # the name of the test will be used as test type in InfluxDB JMeter adapter
        "current_build_number=#{params[:build_number]}",
        "project_id=#{@test_obj.project_id}",
        "env_type=#{@test_obj.env_type}",
        "lg_id=#{@container_name}",
        "influx_protocol=#{@influxdb_obj.protocol}",
        "influx_host=#{@influxdb_obj.host}",
        "influx_port=#{@influxdb_obj.port}",
        "influx_db=#{@influxdb_obj.db_name}",
        "influx_username=#{@influxdb_obj.username}",
        "influx_password=#{@influxdb_obj.password}"
        ]
    }

    @start_params={}

    @test_attributes = helpers.schedule_test(@test_obj,@docker,@influxdb_obj,@schedule_params,@start_params,@container_name)

    #render plain: @test_attributes  #params.inspect

    @request_params={
      "docker_host['id']" => params[:docker_host][:id],
      "build_number" => params[:build_number],
      "docker_image_name" => params[:docker_image_name],
      "id" => params[:id],
      "influxdb_adapter_id" => params[:influxdb_adapter_id]
    }

    @request_params.to_json

    render 'schedule_test'
  end


  def get_dh_images
    require 'json'

    @docker=Docker.find(params[:id])
    @dh_images=JSON.parse(helpers.get_images(@docker))
    
  end

  def index
    @dockers=Docker.all.order("id ASC")
  end

  def edit
    @docker=Docker.find(params[:id])
  end


  def update
    @docker=Docker.find(params[:id])

    if @docker.update(docker_params)
      redirect_to @docker
    else
      render 'edit'
    end

  end

  def list
    @dockers=Docker.all
  end

  def destroy
    @docker=Docker.find(params[:id])
    @docker.destroy
    redirect_to dockers_path
  end

  def show
    @docker= Docker.find(params[:id])
  end

  def create
    @docker = Docker.new(docker_params)     
    @docker.save
    redirect_to @docker
  end
          
  private
    def docker_params
        params.require(:docker).permit(:docker_host_name,:docker_host_fqdn,:docker_host_ram,
        :docker_host_cpu,:docker_host_disk_space,
        :docker_host_location,:docker_host_network_interface_throughput,
        :docker_host_provider_type,:docker_host_api_key,:docker_host_api_cert)
      #render plain: params[:docker].inspect
    end

end
