require 'mongo'
namespace :mongo_namespace do
  desc "TODO"
  task populate_data: :environment do
    puts "namespace:mongo_namespace , task : populate_data execution started"
    client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'test')
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
          puts x.class
          r = client[:movie].insert_one(x) 
          puts r
          puts r.class
        }
        $i +=1
      end
  end

end
