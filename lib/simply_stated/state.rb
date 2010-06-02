require 'simply_stated/transition'

module SimplyStated
  class State
    attr_reader :name

    def initialize(name, &block)
      @name = name
      @transitions = []
      instance_eval &block
    end

    def transitions(message = nil)
      if message
        @transitions.detect { |t| t.message == message }
      else
        @transitions
      end
    end
    
    protected

    def transition(message, destination)
      @transitions << Transition.new(message, destination)
    end
  end
end
