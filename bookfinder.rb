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


def add_book

	print "Input your ISBN number here > "

	isbn = gets.chomp
	url = "http://isbndb.com/api/v2/json/TVVFMNE5/book/#{isbn}"
	resp = Net::HTTP.get_response(URI.parse(url))
	 if resp.code == "200"
		data = JSON.parse(resp.body)
	else
		puts resp.code
		puts "Something went wrong."
	end

	author_name = get_author_name(data)
	title = get_title(data)
	publsh_date = get_publish_date(data)

	book = {
		:author => "#{author_name}",
		:title => "#{title}",
		:publish_date => "#{publsh_date}"
	}

	File.open(FILENAME, "w") do |f|
		DATA[isbn] = book
		f.write(JSON.pretty_generate(DATA))
	end
end

def search_book
	puts "What is it you're looking for? > "
end

def menu
	print "What do you want to do? (add, search) > "

	choice = gets.chomp.downcase
	if choice.include? "add"
		add_book
	elsif choice.include? "search"
	    search_book
	end

	print "Are you finished? > "
	choice = gets.chomp.downcase
	if choice.include? "yes"
		exit(0)
	end
	menu
end

def enter
	puts "Welcome to your library!"
	menu
end

FILENAME = "./bookfinder.json"

if File.exist? FILENAME
	File.open(FILENAME, "r") do |f|
		text = f.read
		begin
			DATA = JSON.parse(text)
		rescue JSON::ParserError => e
			raise e, "Could not read file. Please ensure you have valid JSON in #{FILENAME}"
			exit(1)
		end
	end
else
	DATA = {}
end

enter