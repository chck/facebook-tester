#!/usr/bin/env ruby
#-*- coding:utf-8 -*-
require 'selenium-webdriver'
require 'rainbow'
require 'yaml'

class SeleniumTest
  def initialize
    @url = "https://m.facebook.com/home.php"
    conf = YAML::load(open("../API.yaml"))
    @email = conf["fb_email"]
    @pass = conf["fb_pass"]
    #@bsr = Selenium::WebDriver.for :firefox
    @bsr = Selenium::WebDriver.for :chrome
    @xpath = "//i" #全画像マッチ
    @imagepath = Time.now.to_s.gsub(/\+.*/,"").gsub(/^20|\s|-|:/,"")
    system("mkdir #{@imagepath}") unless File.exist?(@imagepath)
  end

  def main
    @bsr.navigate.to(@url)
    @bsr.find_element(:name,"email").send_key @email
    @bsr.find_element(:name,"pass").send_key @pass
    @bsr.find_element(:name,"login").click

    urls = []
    @bsr.find_elements(:xpath,@xpath).each do |node|
      n=node.attribute("style")
      if /.*background-image: url\((.*?)\)/ =~ n
        urls << $1
      end
    end

    #70文字以下のurlを排除
    s_urls = []
    urls.each do |url|
      if url.size>70
        s_urls << url
      end
    end

    puts Rainbow(@imagepath).yellow.bright
    save_file(s_urls)
    puts Rainbow("-----download end-----").magenta
    @bsr.save_screenshot("#{@imagepath}/screenshot.png")
    @bsr.quit
  end

  def save_file(urls)
    i=0
    urls.each do |url|
      filename = File.basename(url)
      open("#{@imagepath}/#{i+=1}.png", 'wb') do |file|
        file.puts Net::HTTP.get_response(URI.parse(url)).body
      end
    end
  end
end

loop do
  st = SeleniumTest.new
  st.main
  sleep(10)
end
