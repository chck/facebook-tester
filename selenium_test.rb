#!/usr/bin/env ruby
#-*- coding:utf-8 -*-
require 'selenium-webdriver'
require 'webdriver-user-agent'
require 'rainbow'
require 'yaml'

class SeleniumTest
  def initialize
    @url = "https://m.facebook.com/home.php"
    conf = YAML::load(open("../API.yaml"))
    @email = conf["fb_email"]
    @pass = conf["fb_pass"]
    #@bsr = Selenium::WebDriver.for :firefox
    @bsr = Webdriver::UserAgent.driver(:browser => :chrome, :agent => :iphone, :orientation => :portrait)
    @xpath = "//div"
  end

  def main
    @bsr.navigate.to(@url)
    @bsr.find_element(:name,"email").send_key @email
    @bsr.find_element(:name,"pass").send_key @pass
    @bsr.find_element(:name,"login").click
    
    100.times do
      @bsr.action.send_keys(:space).perform
    end

    sleep(1)

    texts = []
    result = ""
    begin
      @bsr.find_elements(:xpath,@xpath).each do |node|
        t=node.text
        if /#{$reg}/ =~ t
          result=t
        end
      end
    rescue
      p=""
    end
    #@bsr.save_screenshot("sc/#{$audience_num}-#{(Time.now-0).round}.png")
    @bsr.quit
    return result
  end
end

$audience_num = 30

$reg = "拾いたい文面"
t0 = Time.now
i=0
res=""
while res.empty? do
  $elapsed = (Time.now-t0-(7.5*i)).round
  puts Rainbow("[#{i+=1}] #{$elapsed} sec").green.bright
  st = SeleniumTest.new
  res=st.main
  puts Rainbow(res).yellow.bright
  puts "-------------------------"
  sleep([*5..10].sample)
end

puts Rainbow($elapsed).magenta.bright
puts $audience_num
