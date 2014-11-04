#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require 'open-uri'
require 'nokogiri'
require 'rexml/document'
require 'kconv'
require 'rainbow'
require 'mechanize'
require 'csv'
require 'yaml'

class MechanizeTest
  def initialize
    @m = Mechanize.new
    conf = YAML::load(open("../API.yaml"))
    @email = conf["fb_email"]
    @password = conf["fb_pass"]
    @path = "//*[@id='m_newsfeed_stream']"
#    @path = "//article"
    @login_url = "https://m.facebook.com/login.php"
    @home_url = "https://m.facebook.com/home.php"
    @is_login = false
  end

  def login(email, password)
    if !@is_login
      @m.get(@login_url) do |page|
        res = page.form_with(:method => 'POST') do |form|
          form.field_with(:name => 'email').value = @email
          form.field_with(:name => 'pass').value = @password
        end.click_button
      end
#      @is_login = !@m.page.uri.to_s.match('home_php').nil?
      @is_login = true
    end
  end

  def main
    login(@email, @password)
    puts Rainbow("success").yellow.bright
    puts Rainbow(@home_url).green.bright
    @m.get(@home_url) do |page|
#      doc = Nokogiri::HTML(page.body)
      doc = Nokogiri::Slop(page.body)
      doc.xpath(@path).each do |node|
#      doc.xpath(@path).children.each do |node|
        p node.to_html#.xpath("//span[@data-sigil='m-feed-voice-subtitle']")
      end
    end 


=begin
    CSV.open(ARGV[0],"r").each do |row|

      #げっとここから      
      #id_num = 12031
      urls = row[0]#url_1+"#{id_num}"
      puts Rainbow(urls).green.bright
      @m.get(urls) do |page|
        doc = Nokogiri::HTML(page.body)
        xp1 = doc.xpath(@path_1)
        xp2 = doc.xpath(@path_2)

        #でーたないない判定
        data?(xp1)
        data?(xp2)

        #hashにへんかん
        su_xp1 = []
        su_xp2 = []
        count = 0
        xp1.each do |row|
          su_xp1 << row.text.gsub(/(\r\n|\r|\n)/,"").gsub(/(^\s+)|(\s+$)/,"")
        end

        puts su_xp1
        # xp2.each do |row|
        #   if(count==12)
        #     su_xp2 << @home+row.elements.attribute("src").value  #画像のURLをげっと！！！
        #   elsif(count==4)
        #     su_xp2 << row.text.gsub(/(\r\n|\r|\n)/,"").gsub(/(^\s+)|(\s+$)|(                           ).*$/,"")#すぺーすさよなら
        #   else
        #     su_xp2 << row.text.gsub(/(\r\n|\r|\n)/,"").gsub(/(^\s+)|(\s+$)/,"")
        #   end
        #   count+=1
        # end
        # ary = [su_xp1,su_xp2].transpose
        # h = Hash[*ary.flatten]#.to_json

        # puts Rainbow(" G E T ").yellow.inverse
        # open("su-list2.txt","a+") do |f|    
        #   f.puts h.values.join(",")
        # end
        # sleep(0.5)  #30フレームだけ待ってやろう
      end

    end
=end
  end
end

mt = MechanizeTest.new
mt.main
