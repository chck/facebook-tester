#!/usr/bin/env ruby
#-*- coding:utf-8 -*-
require 'koala'
require 'yaml'

access_token = YAML::load(open("../API.yaml"))["facebook_access_token"]

graph = Koala::Facebook::API.new(access_token)
begin
  friends = graph.get_connections('me', 'friends', :local => 'ja-jp')
  frineds.each do |friend|
    puts friend['name']
  end
rescue => e
  puts e
end


=begin
search = graph.search('BRAVIA')
search.each do |result|
  puts result['message']
  #poster's information
  who = graph.get_object(result['from']['id'].to_s)
  puts "sex:"+who['gender'].to_s
  puts "d.o.b:"+who['birthday'].to_s
end
=end
