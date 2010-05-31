require 'simply_stated/transition'

module SimplyStated
  class State
    attr_reader :name, :transitions

    def initialize(name, &block)
      @name = name
      @transitions = []
      instance_eval &block
    end
    
    protected

    def transition(message, to_state)
      @transitions << Transition.new(message, to_state)
    end
  end
end
