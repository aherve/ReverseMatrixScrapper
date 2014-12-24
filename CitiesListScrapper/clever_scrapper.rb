#!/usr/bin/env ruby

require './distance_mapper.rb'


if File.exists?('out/cities_with_distances.dat')
  read_codenames = File.open('out/cities_with_distances.dat').map do |line|
    JSON.parse(line.chomp)["codename"]
  end
end


File.open("out/cities_with_distances.dat", 'a') do |file|
  ARGF.each do |line|
    city = line.chomp.split("\t")[1]
    unless read_codenames.include? city
      puts city
      file.puts Mapper.map(line)
    end
  end
end
