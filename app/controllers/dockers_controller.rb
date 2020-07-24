class DockersController < ApplicationController

  def new
#    render plain: params[:host].inspect
  end

  def schedule_test
    @dockers=Docker.all.order("id ASC")
    @test_obj=Test.find(params[:id])
    @influxdb_obj=Influxdb.find(params[:influxdb_adapter_id])
    @test_attributes=JSON.parse(helpers.schedule_test(@test_obj,@dockers[0],@influxdb_obj))
    
    render plain: @test_attributes  #params.inspect
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
        params.require(:docker).permit(:docker_host_fqdn,:docker_host_ram,
        :docker_host_cpu,:docker_host_disk_space,
        :docker_host_location,:docker_host_network_interface_throughput,
        :docker_host_provider_type,:docker_host_api_key,:docker_host_api_cert)
      #render plain: params[:docker].inspect
    end

end
