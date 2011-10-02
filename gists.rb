require 'rubygems'
require 'typhoeus'
require 'json'
require 'gist'


class Gists

  def initialize(username, password)
    @username, @password = username, password
  end

  def get
    next_page = 1
    gists = []
    while next_page do
      response = Typhoeus::Request.get("https://api.github.com/gists?page=#{next_page}", :username => @username, :password => @password)
      next_page = response.headers_hash["Link"][/page=([0-9]+).+next/,1]
      JSON.parse(response.body).each do |gist|
        gists << Gist.new(gist)
      end
    end
    gists
  end

end