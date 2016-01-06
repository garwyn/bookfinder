require 'net/http'
require 'json'
require 'pstore'

def get_author_name(data)
	return data["data"][0]["author_data"][0]["name"]
end

def get_title(data)
	return data["data"][0]["title_latin"]
end

def get_publish_date(data)
	return data["data"][0]["edition_info"]
	#how do I map out that its a paperback? I suppose it's not a big deal,
	#but thats not what I want
end

store = PStore.new("data.pstore")# I think this is working, but how do I tell?

print "Input your ISBN number here > "
ISBN = gets.chomp

url = "http://isbndb.com/api/v2/json/TVVFMNE5/book/#{ISBN}"
resp = Net::HTTP.get_response(URI.parse(url))
#Also, how do I put int the == 200 safeguard? I think it goes here but it blows up.
	data = JSON.parse(resp.body)
	puts JSON.pretty_generate(data)

puts ("-" * 10 ) + ("\n" * 10) + ("-" * 10)

author_name = get_author_name(data)
title = get_title(data)
publsh_date = get_publish_date(data)

puts "MY AUTHOR NAME IS FUCKING BALLER: #{author_name}"
puts "THIS IS THE FUCKING TITLE: #{title}"
puts "This shit was published on #{publsh_date}"
