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
#     @path = "//span"
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
        open("test.html","a+") do |f|
          f.puts node.to_html#.xpath("//span[@data-sigil='m-feed-voice-subtitle']")
        end
      end
    end 
  end
end

mt = MechanizeTest.new
mt.main
