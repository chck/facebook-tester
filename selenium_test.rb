#!/usr/bin/env ruby
#-*- coding:utf-8 -*-
require 'selenium-webdriver'
require 'yaml'

class SeleniumTest
  def initialize
    @url = "https://m.facebook.com/home.php"
    conf = YAML::load(open("../API.yaml"))
    @email = conf["fb_email"]
    @pass = conf["fb_pass"]
    #@bsr = Selenium::WebDriver.for :firefox
    @bsr = Selenium::WebDriver.for :chrome
    #browser.visible = false
    #@path = "//*[@id='m_newsfeed_stream']/div[3]/section[2]/article[4]"
    @path = "//*[@id='m_newsfeed_stream']"
  end

  def main
    @bsr.navigate.to(@url)
    @bsr.find_element(:name,"email").send_key @email
    @bsr.find_element(:name,"pass").send_key @pass
    @bsr.find_element(:name,"login").click
    #browser.find_element(:class,"gsfi").send_key "Hello Webdriver!"
    elm =  @bsr.find_element(:xpath, @path)
    puts elm
    #browser.save_screenshot('sc.png')
    #browser.find_element(:name,"btnK").submit
    #puts browser.title
    #browser.close
  end
end

st = SeleniumTest.new
st.main
