#!/usr/bin/env ruby
#-*- coding:utf-8 -*-
require 'selenium-webdriver'

#driver = Selenium::WebDriver.for :chrome
driver = Selenium::WebDriver.for :firefox
driver.navigate.to("http://google.com")
element = driver.find_element(:name, 'q')
element.send_keys "Hello WebDriver!"
driver.save_screenshot('sc.png')
driver.find_element(:name,"btnK").submit
puts driver.title
driver.close
