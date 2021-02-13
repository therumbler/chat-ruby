# frozen_string_literal: true

class Om
  attr_accessor :go

  def initialize
    @go = true
  end

  def messages
    counter = 1
    while @go
      yield "a message #{counter}"
      counter += 1
      sleep 1
    end
    puts 'INFO: exit messages'
  end
end
