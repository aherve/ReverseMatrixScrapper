#!/usr/bin/env ruby
require 'bundler'
require 'csv'
require 'pry'
require 'faraday'
require 'json'
Bundler.setup(:default)

class Mapper
  attr_accessor :data

  def input_head
    [
      :department,
      :codename,
      :readable_name,
      :lat,
      :lng,
    ]
  end

  def initialize(line)
    @data = input_head.zip(line.chomp.split("\t").map(&:strip)).to_h
  end

  def output
    {
      department: @data[:department],
      codename: @data[:codename],
      readable_name: @data[:readable_name],
      lat: @data[:lat],
      lng: @data[:lng],
      distance: query_result["rows"].first["elements"].first["distance"],
      car_duration: query_result["rows"].first["elements"].first["duration"],
    }.to_json
  end

  def query_params
    {
      origins: '48.86,2.34445',
      destinations: [data[:lat],data[:lng]].join(","),
      mode: 'driving',
    }
  end

  def self.map(line)
    m = self.new(line)
    puts m.output
  end

  def query_result
    @query_result ||= JSON.parse(
      google_conn.get do |req|
        query_params.each do |k,v|
          req.params[k] = v
        end
      end.body
    )
    raise @query_result["status"] unless @query_result["status"] == "OK"
    @query_result
  end

  protected

  def google_conn
    @conn ||= Faraday.new(url: 'http://maps.googleapis.com/maps/api/distancematrix/json') do |faraday|
      faraday.request :url_encoded
      faraday.adapter Faraday.default_adapter
    end
  end

end

ARGF.each do |line|
  Mapper.map(line)
end
