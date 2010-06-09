require 'simply_stated/transition'

module SimplyStated
  class State
    attr_reader :name

    def initialize(name, &block)
      @name = name
      @transitions = []
      yield self
    end

    def transitions(message = nil)
      if message
        @transitions.detect { |t| t.message == message }
      else
        @transitions
      end
    end
    
    def transition(message, destination, &block)
      @transitions << Transition.new(message, destination, &block)
    end
  end
end
