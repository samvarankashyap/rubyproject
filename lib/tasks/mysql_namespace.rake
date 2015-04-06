require 'mysql2'
require 'net/http'
namespace :mysql_namespace do
  desc "TODO"
  task populate_data: :environment do
    puts "namespace : mysql_namespace, task: populate_data execution started"
   
    begin
      out_file = File.read("config/db_config.json")
      data_hash = JSON.parse(out_file)
      user_name = data_hash['dbs']['mysql']['username']
      password = data_hash['dbs']['mysql']['password']
      database = data_hash['dbs']['mysql']['database']
      puts user_name 
      puts password
      puts database

      puts "Initiating connection with mysql on localhost"
      con = Mysql2::Client.new(:host => "localhost", :username => user_name ,:password => password, :database => database)
      results = con.query("CREATE TABLE IF NOT EXISTS movies(id INT PRIMARY KEY AUTO_INCREMENT ,movie_id INT , name VARCHAR(100) , original_name VARCHAR(100),first_air_date  VARCHAR(100) , poster_path  VARCHAR(100), popularity DOUBLE(20,15), vote_average DOUBLE , vote_count INT, media_type VARCHAR (10))")
      $i = 1
      $num = 600
      while $i < $num  do
        if $i%30 == 0 then 
          sleep(30)
        end
        s1 = "http://api.themoviedb.org/3/search/multi?query=A&page=#$i&api_key=7991962ef09715df799931ae03bec180"
        url = URI.parse(s1)
        req = Net::HTTP::Get.new(url.to_s)
        res = Net::HTTP.start(url.host, url.port) {|http|
        http.request(req)
        }
        response = JSON.parse(res.body)
        results = response["results"]
        puts results.class
        results.each { |x| 
          puts x
          puts x.class
          query =  "INSERT INTO movies(movie_id,name,original_name,first_air_date,popularity,media_type)"
          query +=  "VALUES("
          query += x["id"].to_s+","
          name = x["name"].to_s
          #name.sub! '\'', ' '
          name.gsub!(/'/, ' ')
          puts name
          o_name = x["original_name"].to_s
          #o_name.sub! '\'', ' '
          o_name.gsub!(/'/, ' ') 
          query += "'"+name+"'"+","
          query += "'"+o_name+"'"+","
          query += "'"+x["first_air_date"].to_s+"'"+","
          query += x["popularity"].to_s+","
          query += "'"+x["media_type"].to_s+"'"
          query += ")"
          #query = "INSERT INTO movies(movie_id,name,original_name,first_air_data,poster_path,popularity,vote_average,vote_count,media_type) VALUES('"+x["id"].to_i+"','"+x["name"].to_i+"','"+x["original_name"].to_i+"','"+x["first_air_data"].to_i+"','"+x["poster_path"].to_i+"','"+x["popularity"].to_i+"','"+x["vote_average"].to_i+"','"+x["vote_count"].to_i+"','"+x["media_type"].to_i+"')"
          puts query
          con.query(query)
           
        }
        $i +=1
      end
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
      puts "Error occured"
      exit 1
    end
  end

end
