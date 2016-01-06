require "rubygems"
require "json"
require "net/http"
require "uri"

uri = URI.parse("http://isbndb.com/api/v2/json/TVVFMNE5/book/9780557211760")

http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::get.new(uri.request_uri)

response = http.request(request)


if response.code == "200"
	result = JSON.parse(response.body)
end

author = result["data"][0]["author data"][0]["name"]