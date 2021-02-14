# frozen_string_literal: true

require_relative './om'
class Processor
  def initialize(ws)
    puts 'DEBUG: connected'
    @go = true
    @ws = ws
    @om = Om.new
    ws.on :message do |event|
      self.process_client_event(event.data)
    end

    ws.on :close do |event|
      p [:close, event.code, event.reason]
      @om.disconnect
      ws = nil
    end
    Thread.new do |_task|
      self.background
    end
  end

  def process_om_event(event)
    @ws.send(event.to_json)
    if event[0] == 'strangerDisconnected'
      @om.disconnect
      @om.start
    end
  end
  def process_om_events(events)
    unless events
      return
    end
    events.each do |event|
      self.process_om_event(event)
    end
  end
  def process_command(cmd)
    if cmd == '/n'
      @om.disconnect
      @om.start
    end
  end
  def process_client_event(event)
    if event.start_with? '/'
    else
      @om.send_message(event)
    end
  end
  def background
    puts 'DEBUG: start background'
    @om.events do |events|
      self.process_om_events(events)
      # sleep 1
    end
    puts 'ERROR: exit background'
    sleep 2
    self.background
  end
end
