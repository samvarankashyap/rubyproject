namespace :commondb_namespace do
  desc "TODO"
  task initialise: :environment do
    puts "Initialising databases"
    out_file = File.read("config/db_config.json")
    data_hash = JSON.parse(out_file)
    data_hash["dbs"].each do |key, array|
      puts array["name"]
      if array["name"]=="mysql" then
        cmd = "mysql -h localhost -u"+array["username"]+" -p"+array["password"]+" -e \"CREATE DATABASE moviedb;\""
        puts cmd
        result = system(cmd)
        if result == true then
          puts "Database Initialised : Database name : moviedb"
        end 
      end
    end
  end
end
