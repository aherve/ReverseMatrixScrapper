#!/usr/bin/env ruby

require 'bundler'
require 'csv'
require 'pry'
Bundler.setup(:default)

csv_head = [
  :index,
  :department,
  :codename,
  :upcase_name,
  :downcase_name,
  :readable_name,
  :unknown,
  :unknown,
  :zipcode,
  :unknown,
  :unknown,
  :unknown,
  :unknown,
  :unknown,
  :unknown,
  :unknown,
  :unknown,
  :population,
  :unknown,
  :lng,
  :lat,
]

head = [
  :department,
  :codename,
  :readable_name,
  :lat,
  :lng,
  :population,
]

# reformatting csv
cities = CSV::read('./data_raw/villes_france.csv').map{|a| csv_head.zip(a)}.map(&:to_h).map{|h| h.select{|k,v| head.include? k}}

File.open('./formatted_cities.csv', 'w') do |f|
  f.puts head.join("\t")
  cities.each do |city|
    f.puts head.map{|k| city[k]}.join("\t")
  end
end
