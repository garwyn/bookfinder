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

	begin
		resp = Net::HTTP.get_response(URI.parse(url))
	rescue SocketError => e
		puts e.message
		puts "Please connect to the internet."
		return
	rescue URI::InvalidURIError => e
		puts "Invalid URI. Please make sure your ISBN number is correct. (#{isbn})"
		return
	end

	if resp.code == "200"
		data = JSON.parse(resp.body)
		if data["error"]
			puts data["error"]
			return
		end
	elsif resp.code == "404"
		puts "Cannot find book with that ISBN #."
		return
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

	puts "book is #{book}"

	DATA[isbn] = book

	File.open(FILENAME, "w") do |f|
		f.write(JSON.pretty_generate(DATA))
	end
end

def search_book
	puts "What is it you're looking for? (Title, Author, Publish Date) "
	choice = gets.chomp.downcase
	if choice == "title"
		puts search("title")
	elsif choice == "author"
		puts search("author")
	elsif choice == "publish date"
		puts search("publish_date")
	end
end

def search(field)
	print "Enter in the #{field} for the book you're looking for. > "
	input = gets.chomp.downcase
    matches = []

	DATA.each do |isbn, book|
		if input == book[field].downcase
			matches.push(book)
		end
	end

	return matches
end

def delete
	print "Enter the ISBN number of the book you wish to delete. > "
	isbn = gets.chomp

	if DATA.has_key?(isbn)
		DATA.delete(isbn)

		File.open(FILENAME, "w") do |f|
			f.write(JSON.pretty_generate(DATA))
		end

		puts "Deleted book with isbn \"#{isbn}\" successfully"
	else
		puts "Sorry. couldn't find that book."	
	end
end

def menu
	print "What do you want to do? (add, search, delete) > "

	choice = gets.chomp.downcase
	if choice.include? "add"
		add_book
	elsif choice.include? "search"
	    search_book
	elsif choice.include? "delete"
		delete
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

def get_data(filename)
	if File.exist? filename
		File.open(filename, "r") do |f|
			text = f.read
			begin
				return JSON.parse(text)
			rescue JSON::ParserError => e
				raise e, "Could not read file. Please ensure you have valid JSON in #{filename}"
				exit(1)
			end
		end
	else
		return {}
	end
end

FILENAME = "./bookfinder.json"
DATA = get_data(FILENAME)

enter
