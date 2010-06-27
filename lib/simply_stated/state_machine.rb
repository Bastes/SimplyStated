require 'simply_stated/state'

module SimplyStated
  # =StateMachine
  #
  # This class is used by the classes including the SimplyStated::Stated
  # module to holds a state machine definition (basically a collection of
  # states the machine instances can take including their transitions).
  class StateMachine
    # The definition block recieves this instance as unique argument
    def initialize(&block) # :yields: state_machine
      @states = []
      yield self
    end

    # Returns the initial state of the machine
    def initial
      (@states.detect { |state| state.initial? } || @states.first).initial
    end

    # Returns the list of all states of the machine, or just the state with
    # given name when it's provided
    def states(name = nil)
      if name
        @states.detect { |s| s.name == name }
      else
        @states
      end
    end
    
    # Defines a state
    # 
    # see SimplyStated::State.new
    def state(*options, &block) # :yields: state
      @states << State.new(*options, &block)
    end
  end
end
