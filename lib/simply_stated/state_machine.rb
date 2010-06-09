require 'simply_stated/state'

module SimplyStated
  class StateMachine
    def initialize(&block)
      @states = []
      yield self
    end

    def initial
      @states.first
    end

    def states(name = nil)
      if name
        @states.detect { |s| s.name == name }
      else
        @states
      end
    end
    
    def state(name, &block)
      @states << State.new(name, &block)
    end
  end
end
