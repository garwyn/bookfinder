#!/usr/bin/ruby

require 'net/http'
require 'json'
require 'csv'

def get_author_name(data)
	return data["data"][0]["author_data"][0]["name"]
end

def get_title(data)
	return data["data"][0]["title_latin"]
end

def get_publish_date(data)
	published = data["data"][0]["edition_info"].split[1]
	return published
end

print "Input your ISBN number here > "
ISBN = gets.chomp

url = "http://isbndb.com/api/v2/json/TVVFMNE5/book/#{ISBN}"
resp = Net::HTTP.get_response(URI.parse(url))
 if resp.code == "200"
	data = JSON.parse(resp.body)
	puts JSON.pretty_generate(data)
else
	puts resp.code
	puts "Something went wrong."
end

puts ("-" * 10 ) + ("\n" * 10) + ("-" * 10)

author_name = get_author_name(data)
title = get_title(data)
publsh_date = get_publish_date(data)

puts "MY AUTHOR NAME: #{author_name}"
puts "THIS IS THE TITLE: #{title}"
puts "This was published on #{publsh_date}"

book = {
	:author => "#{author_name}",
	:title => "#{title}",
	:publish_date => "#{publsh_date}"
}

CSV.open("./bookfinder.csv", "a") do |csv|
	csv << [book[:author], book[:title], book[:publish_date]]
end

