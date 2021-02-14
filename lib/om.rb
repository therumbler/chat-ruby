# frozen_string_literal: true
require 'json'
require 'net/http'
require 'securerandom'

class Om
  USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.75.14 (KHTML, like Gecko) Version/7.0.3 Safari/7046A194A"
  
  def initialize
    @go = true
    @urls = []
    for i in 1..20
      @urls << "https://front#{i}.omegle.com"
      # @urls << "https://httpbin.org"
    end
    @front_url = @urls.sample
    puts "front_url #{@front_url}"
    @client_id = nil
    
    self.start
  end

  def _call(endpoint, method, **kwargs)
    uri = URI("#{@front_url}/#{endpoint}")
    puts "INFO: #{method.upcase} #{uri} #{kwargs}"
    Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
      if method == 'get'
        uri.query = URI.encode_www_form(kwargs)
        req = Net::HTTP::Get.new uri
        req['USER_AGENT'] = USER_AGENT
        response = http.request req
      else
        response = Net::HTTP.post_form(uri, kwargs)
      end
      begin
        JSON.parse(response.body)
      rescue JSON::ParserError
        {}
      end
    end
  end

  def start
    # resp = self._call('start', client_id: @client_id)
    randid = SecureRandom.hex[0..10]
    params = {randid: randid, firstevents:'1'}
    resp = self._call('start', 'get', params)
    @client_id = resp['clientID']
    @events = resp['events']
    puts "INFO: start events #{@events}"
    puts "client_id = #{@client_id}"
    @go = true
  end

  def disconnect
    @go = false
    resp = self._call('disconnect', 'post', id: @client_id)
  end

  def send_message(msg)
    self._call('send', 'post', id: @client_id, msg: msg)
  end
  
  def events
    while @go
      unless @client_id
        puts 'ERROR: no client_id'
        @go = false
        return
      end
      unless @events
        @events = self._call('events', 'post', id: @client_id)
      end
      puts "INFO: events  #{@events.to_s}"
      yield @events
      @events = nil
    end
    puts 'INFO: exit messages'
  end
end
