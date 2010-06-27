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
    # callback triggered when leaveing the state
    attr_reader :leave
    # super-state (if any)
    attr_reader :sup

    # Creating a new state, a name is required (unique in the state's context),
    # some options may be set in an hash :
    # initial:: true when the state should be the inital state in its context
    # enter, leave:: callbacks triggered when entering or leaving the state
    # 
    # Transitions are defined in the block using this instance's transition
    # method.
    def initialize(name, *options, &block) # :yields: state
      options = options.first || {}
      @name = name
      @transitions = []
      @initial = options[:initial]
      @enter = options[:enter]
      @leave = options[:leave]
      @sup = options[:sup]
      yield self
    end

    # defines a sub-state inside this state, making it a super-state
    # see SimplyStated::State#new
    def state(name, *args, &block) # :yields: state
      args = [((args && args.first) || {}).merge({:sup => self})]
      @states ||= []
      @states << State.new(name, *args, &block)
    end

    # Returns the list of all sub states of this super state, or just the state
    # with given name when it's provided
    def states(name = nil)
      if name
        @states.detect { |s| s.name == name }
      else
        @states
      end
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
    def transition(*args, &block) # :yields: transition
      @transitions << Transition.new(*args, &block)
    end

    # Returns true if this is the initial state
    def initial?
      @initial || false
    end

    # Returns the inital sub-state (if any)
    def initial
      if @states.nil? || @states.empty?
        self
      else
        (@states.detect { |state| state.initial? } || @states.first).initial
      end
    end
  end
end
