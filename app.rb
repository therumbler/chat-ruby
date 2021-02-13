require 'faye/websocket'

require_relative './processor'

def read_index
  file = File.open('./static/index.html')
  contents = file.read
  file.close
  contents
end

App = lambda do |env|
  if Faye::WebSocket.websocket?(env)
    ws = Faye::WebSocket.new(env)
    Processor.new ws

    # Return async Rack response
    ws.rack_response
  else
    # Normal HTTP request
    html = read_index
    [200, { 'Content-Type' => 'text/html', 'Content-Length' => html.length.to_s }, [html]]
  end
end