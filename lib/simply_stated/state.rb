require 'simply_stated/transition'

module SimplyStated
  # =State
  #
  # This class presents a state, with its transitions
  class State
    # name identifying the state
    attr_reader :name
    # callback triggered when entering the state
    attr_reader :enter
    # callback triggered when exiting the state
    attr_reader :exit
    # true when the state is the inital state of the machine
    attr_reader :initial

    # Creating a new state, a name is required (unique in the state's context),
    # some options may be set in an hash :
    # initial:: true when the state should be the inital state in its context
    # enter, exit:: callbacks triggered when entering or leaving the state
    # 
    # Transitions are defined in the block using this instance's transition
    # method.
    def initialize(name, *options, &block) # :yields: state
      options = options.first || {}
      @name = name
      @transitions = []
      @initial = options[:initial]
      @enter = options[:enter]
      @exit = options[:exit]
      yield self
    end

    # Returns the list of transitions for this state or a specific transition
    # matching given message.
    def transitions(message = nil)
      if message
        @transitions.detect { |t| t.message == message }
      else
        @transitions
      end
    end
    
    # Defines a transition in this state
    #
    # see SimplyStated::Transition.new
    def transition(message, destination, &block) # :yields: transition
      @transitions << Transition.new(message, destination, &block)
    end
  end
end
