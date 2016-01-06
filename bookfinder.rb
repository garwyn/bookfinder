require "net/http"

class BookFinder
	content = open("http://isbndb.com/api/v2/json/TVVFMNE5/book/9780557211760")
	puts content.body
end
