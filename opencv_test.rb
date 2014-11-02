#!/usr/bin/env ruby
#-*- coding:utf-8 -*-
require 'opencv'
include OpenCV

input_window = GUI::Window.new('Input')
output_window = GUI::Window.new('Output')

begin
  input_img = CvMat.load("./lenna.png")
rescue => e
  puts e
end

output_img = input_img.BGR2GRAY.canny(120,200)

input_window.show(input_img)
output_window.show(output_img)

GUI::wait_key
GUI::Window.destroy_all
