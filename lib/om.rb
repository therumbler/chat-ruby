# frozen_string_literal: true
require 'json'
require 'net/http'
require 'securerandom'

class Om
  attr_accessor :go
  
  def initialize
    @go = true
    @urls = []
    for i in 1..20
      @urls << "https://front#{i}.omegle.com"
    end
    @front_url = @urls.sample
    puts "front_url #{@front_url}"
    @client_id = SecureRandom.hex
    puts "client_id = #{@client_id}"
    self.start
  end

  def _call(endpoint, **kwargs)
    uri = URI("#{@front_url}/#{endpoint}")
    puts "INFO: kwargs #{kwargs}"
    Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
      req = Net::HTTP::Get.new uri
      Net::HTTP.post_form(uri, kwargs)
      response = http.request req
      return response.body.to_json
    end
  end

  def start
    resp = self._call('start', client_id: @client_id)
    puts "INFO: start resp #{resp}"
  end

  def events
    counter = 1
    while @go
      resp = self._call('events', client_id: @client_id)
      puts "INFO: resp  #{resp.to_s}"
      yield resp
      counter += 1
      sleep 1
    end
    puts 'INFO: exit messages'
  end
end
