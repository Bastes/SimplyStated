require 'simply_stated/state'

module SimplyStated
  class StateMachine
    def initialize(&block)
      @states = []
      instance_eval &block
    end

    def initial
      @states.first
    end

    protected

    def state(name, &block)
      @states << State.new(name, &block)
    end
  end
end
