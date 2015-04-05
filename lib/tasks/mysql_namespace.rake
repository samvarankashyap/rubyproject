require 'mysql2'
require 'net/http'
namespace :mysql_namespace do
  desc "TODO"
  task populate_data: :environment do
    puts "namespace : mysql_namespace, task: populate_data execution started"
    $i = 1
    $num = 10000

    while $i < $num  do
      s1 = "http://api.themoviedb.org/3/search/multi?query=A&page=#$i&api_key=7991962ef09715df799931ae03bec180"
      url = URI.parse(s1)
      req = Net::HTTP::Get.new(url.to_s)
      res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
      } 
      puts res.body
      $i +=1
    end    




    begin
      puts "Initiating connection with mysql on localhost"
      db = Mysql2::Client.new(:host => "localhost", :username => "root",:password => "root", :database => "testdb")
      results = db.query("SELECT * FROM EMPLOYEE")
      results.each do |row|
        puts row["SSN"] # row["id"].class == Fixnum
      end
      #con.query("CREATE TABLE IF NOT EXISTS Writers(Id INT PRIMARY KEY AUTO_INCREMENT, Name VARCHAR(25))")
      #con.query("INSERT INTO Writers(Name) VALUES('Jack London')")
      #con.query("INSERT INTO Writers(Name) VALUES('Honore de Balzac')")
      #con.query("INSERT INTO Writers(Name) VALUES('Lion Feuchtwanger')")
      #con.query("INSERT INTO Writers(Name) VALUES('Emile Zola')")
      #con.query("INSERT INTO Writers(Name) VALUES('Truman Capote')")
    rescue Mysql2::Error => e
      puts e.errno
      puts e.error
      puts "Error occured"
      exit 1
    end
  end

end
