class InfluxdbsController < ApplicationController

  def new
  end



  def index
    @influxdbs=Influxdb.all.order("id ASC")
  end

  def edit
    @influxdb=Influxdb.find(params[:id])
  end


  def update
    @influxdb=Influxdb.find(params[:id])

    if @influxdb.update(influxdb_params)
      redirect_to @influxdb
    else
      render 'edit'
    end

  end

  def destroy
    @influxdb=Influxdb.find(params[:id])
    @influxdb.destroy
    redirect_to influxdbs_path
  end

  def show
    @influxdb= Influxdb.find(params[:id])
  end

  def create
    @influxdb = Influxdb.new(influxdb_params)     
    @influxdb.save
    redirect_to @influxdb
  end
          
  private
    def influxdb_params
        params.require(:influxdb).permit(:adapter_name,:host,:port,
        :username,:password,
        :db_name,:protocol)
      #render plain: params[:docker].inspect
    end

end
