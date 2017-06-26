require 'open-uri'
require 'nokogiri'
require 'uri'
require 'cgi'
require 'wombat'
require 'mechanize'

class IteratorCrawler
  include Wombat::Crawler

  base_url "http://www.cine21.com"
  path "/movie/lists/playing"

  movies "xpath=//li[@class='mov_info_li']", :iterator do
    link "xpath=./a/@href"
    title "xpath=./a/div/span[@class='tit']/text()"
  end

end
#IteratorCrawler.new.crawl

class HomeController < ApplicationController
  def index
    one = Nokogiri::HTML(open("http://www.cine21.com/movie/lists/playing"))
    @link = one.xpath("//li[@class='mov_info_li']/a")
    @title = one.xpath("//span[@class='tit']")
    
    mechanize = Mechanize.new

    page = mechanize.get('http://www.cine21.com/movie/lists/playing')

    @data = []

    for i in 0..20
        tmp = []
        begin
        title = page.at("#content > ul.mov_info_list > li:nth-child(#{i}) > a > div > span.tit").inner_text
        link = "http://www.cine21.com" + page.at("#content > ul.mov_info_list > li:nth-child(#{i}) > a")['href']
        rescue

        end
        tmp << title
        tmp << link
        @data << tmp
    end

    @wb = IteratorCrawler.new.crawl

    
  end

  def result
    de_name = CGI::escape(params[:search])
    one = Nokogiri::HTML(open("http://www.cine21.com/search/movie/?q=#{de_name}"))
    @result = one.xpath("//p[@class='name']/a")
  end
end
