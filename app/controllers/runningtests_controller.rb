class RunningtestsController < ApplicationController

  def new
  end

  def index
    @runningtests = Runningtest.all.order("id ASC")
  end

  def edit
  end


  def update
    results_hash = {
        "status" => params[:test_results][:status],
        "details" => params[:test_results]
    }
    @runningtest=Runningtest.find(params[:id])
    @runningtest.update(results_hash)
  end

  def destroy
    @runningtest=Runningtest.find(params[:id])
    helpers.stop_container(@runningtest, Docker.find(@runningtest.docker_host_id))
    @runningtest.destroy
    redirect_to runningtests_path
  end

  def show
  end

  def create
  end

  private
    def runningtest_params
        params.require(:runningtest).permit(:container_name, :docker_host, 
        :influxdb_adapter_id, :test_params, :status, :details)
    end

  
end
