require 'net/http'
require 'json'

def get_author_name(data)
	return data["data"][0]["author_data"][0]["name"]
end

def get_title(data)
	return data["data"][0]["title_latin"]
end

print "Input your ISBN number here > "
ISBN = gets.chomp

url = "http://isbndb.com/api/v2/json/TVVFMNE5/book/#{ISBN}"
resp = Net::HTTP.get_response(URI.parse(url))

data = JSON.parse(resp.body)
puts JSON.pretty_generate(data)

puts ("-" * 10 ) + ("\n" * 10) + ("-" * 10)

author_name = get_author_name(data)
title = get_title(data)

puts "MY AUTHOR NAME IS FUCKING BALLER: #{author_name}"
puts "THIS IS THE FUCKING TITLE: #{title}"