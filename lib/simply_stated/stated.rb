require 'simply_stated/state_machine'

module SimplyStated
  module Stated
    def self.included(base)
      base.class_eval {
        def self.describe_states(&block)
          @@state_machine = SimplyStated::StateMachine.new(&block)
        end

        def self.states(*args)
          @@state_machine.states(*args)
        end
      }
    end

    def initialize
      @state = @@state_machine.initial
    end

    def state
      @state
    end

    def method_missing(method_name, *args)
      if transition = @state.transitions(method_name)
        if ! transition.callback || transition.callback.call(self, *args)
          @state = @@state_machine.states(transition.destination)
          @state.enter.call(self) if @state.enter
        end
      else
        super
      end
    end
  end
end
