require 'faye/websocket'


def read_index
  file = File.open('./static/index.html')
  contents = file.read
  file.close
  contents
end

App = lambda do |env|
  if Faye::WebSocket.websocket?(env)
    ws = Faye::WebSocket.new(env)

    ws.on :message do |event|
      ws.send(event.data)
    end

    ws.on :close do |event|
      p [:close, event.code, event.reason]
      ws = nil
    end

    # Return async Rack response
    ws.rack_response
  else
    # Normal HTTP request
    html = read_index
    [200, { 'Content-Type' => 'text/html', 'Content-Length' => html.length.to_s }, [html]]
  end
end