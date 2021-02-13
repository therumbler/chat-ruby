class Processor
    # include Concurrent::Async
    def initialize(ws)
        ws.on :message do |event|
            ws.send(event.data)
        end

        ws.on :close do |event|
            p [:close, event.code, event.reason]
            ws = nil
        end
    end

end