# frozen_string_literal: true

require_relative './om'
class Processor
  def initialize(ws)
    puts 'DEBUG: connected'
    @go = true
    @ws = ws
    @om = Om.new
    ws.on :message do |event|
      ws.send(event.data)
    end

    ws.on :close do |event|
      p [:close, event.code, event.reason]
      @om.go = false
      ws = nil
    end
    Thread.new do |_task|
      self.background
    end
  end

  def background
    puts 'DEBUG: start background'
    @om.events do |event|
      @ws.send(event.to_json)
      # sleep 1
    end
    puts 'ERROR: exit background'
  end
end
