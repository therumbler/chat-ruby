# frozen_string_literal: true

require 'faye/websocket'

require_relative './processor'

def read_static(path)
  path = path.gsub("/static/", "")
  puts "DEBUG: path #{path}"
  file = File.open("./static/#{path}")
  contents = file.read
  file.close
  contents
end

def process_static(env)
  puts "INFO: REQUEST_PATH #{env['REQUEST_PATH']}"
  content_type = 'text/html'
  if env['REQUEST_PATH'].start_with? '/static'
    if env['REQUEST_PATH'].end_with? '.js'
      content_type = 'text/javascript;charset=UTF-8'
    end
    contents = read_static(env['REQUEST_PATH'])
  end

  if env['REQUEST_PATH'] == '/'
    puts 'DEBUG: load index.html'
    contents = read_static('/static/index.html')
  end
  return contents, content_type
end

App = lambda do |env|
  if Faye::WebSocket.websocket?(env)
    ws = Faye::WebSocket.new(env)
    Processor.new ws
 
    # Return async Rack response
    ws.rack_response
  else
    # Normal HTTP request
    (contents, content_type) = process_static(env)
    # html = read_index
    if contents
      [
        200, 
        { 
          'Content-Type' => content_type, 
          'Content-Length' => contents.length.to_s 
        },
        [contents]
      ]
    else
      [400, {'content-type'=>'text/plain'}, ['not found']]
    end
  end
end
