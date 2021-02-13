
class Processor
    def initialize(ws)
        @go = true
        @ws = ws
        ws.on :message do |event|
            ws.send(event.data)
        end

        ws.on :close do |event|
            p [:close, event.code, event.reason]
            @go = false
            ws = nil
        end
    end
    def background
        while @go
            @ws.send('hi from background')
            sleep 1
        end
        puts "ERROR: exit background"
    end
end