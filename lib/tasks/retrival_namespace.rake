require 'mysql2'
require 'mongo'
include Mongo
namespace :retrival_namespace do
  desc "TODO"
  task mongo_select: :environment do
    out_file = File.read("config/db_config.json")
    data_hash = JSON.parse(out_file)
    database = data_hash['dbs']['mongo']['database']
    puts database
    client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => database)
    client[:movie].find( :id =>60089).each do |document|
    puts document.to_s
    end
    client[:movie].find( :media_type =>"tv", :name => "Arrow").each do |document|
    puts document.to_s
    end 
  end
  desc "TODO"
  task mysql_select: :environment do
      out_file = File.read("config/db_config.json")
      data_hash = JSON.parse(out_file)
      user_name = data_hash['dbs']['mysql']['username']
      password = data_hash['dbs']['mysql']['password']
      database = data_hash['dbs']['mysql']['database']
      puts user_name
      puts password
      puts database
      begin
        puts "Initiating connection with mysql on localhost"
        con = Mysql2::Client.new(:host => "localhost", :username => user_name ,:password => password, :database => database)
        query1 = 'SELECT * from movies where movie_id=60089'
        query2 = 'SELECT * from movies where media_type="tv" and name="Arrow"'
        puts "query1 : "+query1
        rs1 = con.query query1
        rs2 = con.query query2
        rs1.each do |row|
         puts row # row["id"].class == Fixnum
        end
        puts "query2 :"+query2
        rs2.each do |row|
         puts row # row["id"].class == Fixnum
        end
      rescue Mysql2::Error => e
        puts e.errno
        puts e.error
      ensure
        con.close if con
    end
  end
end
