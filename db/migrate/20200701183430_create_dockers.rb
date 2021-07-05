class CreateDockers < ActiveRecord::Migration[6.0]
  def change
    create_table :dockers do |t|
      t.belongs_to :test
      t.string :docker_host_name
      t.string :docker_host_fqdn
      t.integer :docker_host_ram
      t.integer :docker_host_cpu
      t.float :docker_host_disk_space
      t.string :docker_host_location
      t.float :docker_host_network_interface_throughput
      t.string :docker_host_provider_type
      t.text :docker_host_api_key
      t.text :docker_host_api_cert
      t.timestamps
    end

    create_table :tests do |t|
      t.string :git_repo_url
      t.text :git_repo_key
      t.string :user_id 
      t.integer :build_number
      t.string :project_id
      t.string :env_type
      t.integer :cpu_cores
      t.integer :ram
      t.string :test_scope
      t.string :test_type
      t.integer :influxdb_adapter_id
      t.timestamps
    end

    create_table :influxdbs do |t|
      t.string :adapter_name
      t.string :host
      t.string :port
      t.string :db_name
      t.string :protocol
      t.string :username
      t.string :password
    end

    create_table :runningtests do |t|
      t.string :container_name
      t.integer :docker_host_id
      t.integer :influxdb_adapter_id
      t.string :test_params
      t.string :status
      t.string :details
    end

  end

end
