namespace :commondb_namespace do
  desc "TODO"
  task initialise: :environment do
    puts "Initialising databases"
    out_file = File.read("config/db_config.json")
    #...
    data_hash = JSON.parse(out_file)
    #...
    puts data_hash['dbs']['db1']['name']
  end

end
