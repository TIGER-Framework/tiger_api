class TestsController < ApplicationController

  def new
  end

  def schedule
    @test=Test.find(params[:id])
  end

  def index
    @tests=Test.all.order("id ASC")
  end

  def edit
    @test=Test.find(params[:id])
  end


  def update
    @test=Test.find(params[:id])

    if @test.update(test_params)
      redirect_to @test
    else
      render 'edit'
    end

  end

  def destroy
    @test=Test.find(params[:id])
    @test.destroy
    redirect_to tests_path
  end

  def show
    @test= Test.find(params[:id])
  end

  def create
    @test = Test.new(test_params)     
    @test.save
    redirect_to @test
  end
          
  private
    def test_params
        params.require(:test).permit(:git_repo_url,:git_repo_key,
        :user_id,:cpu_cores, :influxdb_adapter_id,
        :ram,:test_type,:test_scope,:build_number,:project_id, :env_type)
      #render plain: params[:docker].inspect
    end

end
