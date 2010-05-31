require 'simply_stated/state_machine'

module SimplyStated
  module Stated
    def self.included(base)
      base.class_eval {
        def self.states(&block)
          @@state_machine = SimplyStated::StateMachine.new(&block)
        end
      }
    end

    def initialize
      @state = @@state_machine.initial
    end

    def state
      @state
    end
  end
end
