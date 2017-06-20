require 'open-uri'
require 'nokogiri'
require 'uri'
require 'cgi'

class HomeController < ApplicationController
  def index
    one = Nokogiri::HTML(open("http://www.cine21.com/movie/lists/playing"))
    @link = one.xpath("//li[@class='mov_info_li']/a")
    @title = one.xpath("//span[@class='tit']")
  end

  def result
    de_name = CGI::escape(params[:search])
    one = Nokogiri::HTML(open("http://www.cine21.com/search/movie/?q=#{de_name}"))
    @result = one.xpath("//p[@class='name']/a")
  end
end
