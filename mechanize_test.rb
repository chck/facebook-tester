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
    @xpath = "//a"
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
      @is_login = true
    end
  end

  def main
    login(@email, @password)
    result = ""
    nodes = []
    @m.get(@home_url) do |page|
      doc = Nokogiri::Slop(page.body)
      doc.xpath(@xpath).each do |node|
        nodes << node
        #open("test.html","a+") do |f|
        n=node.text
#        open("test.txt","a+") do |f|
          puts n
#        end
        if /#{$text}/ =~ n
          result = node.to_html
        end
      end
    end 
    p nodes.size
    return result
  end
end

$text = "引っ掛けたい文面"
t0 = Time.now
#loop do
  puts Rainbow(Time.now-t0).green.bright
  mt = MechanizeTest.new
  puts Rainbow(res = mt.main).yellow.bright
#  break unless res.empty?
#  sleep([*5..10].sample)
#end

puts "---end---"
puts Rainbow(Time.now-t0).magenta.bright
