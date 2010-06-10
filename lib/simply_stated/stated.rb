require 'simply_stated/state_machine'

module SimplyStated
  # =Stated
  #
  # This module gives a class the hooks to define a state machine behaviour.
  # All you need to do is include this module, describe the machine using
  # the describe_states method and voilà : instant state machine !
  #
  # Exemple :
  #   require 'simply_stated'
  #
  #   class Machine
  #     # required to define the state machine and add behaviour
  #     include SimplyStated::Stated
  #
  #     # begins the description
  #     describe_states do |d|
  #
  #       # describes the initial state
  #       d.state(:state_1, :initial => true) do |s|
  #
  #         # describing a transitions
  #         s.transition(:goto_2, :state_2)
  #
  #         # this transition has got a transition callback
  #         s.transition(:goto_3, :state_3) do |m, *args|
  #           # transitions may receive arguments
  #           m.do_whatever_with(*args)
  #
  #           # transition callbacks must return true to validate, or false to
  #           # prevent state change ; transitions without callbacks always
  #           # validate
  #           true
  #         end
  #       end
  #
  #       # this state has an enter hook ; enter hooks are triggered when the
  #       # machine enters the state
  #       d.state(:state_2, :enter => lambda { |m| m.do_something }) do
  #         # ...
  #       end
  #
  #       # this state has an exit hook ; exit hooks are triggered when the
  #       # machine exits the state
  #       d.state(:state_3, :exit => lambda { |m| m.do_something_else }) do
  #         # ...
  #       end
  #     end
  #   end
  module Stated
    def self.included(base) # :nodoc:
      base.class_eval {
        # Starts states description
        #
        # see SimplyStated::StateMachine.new
        def self.describe_states(&block) # :yields: state_machine
          @@state_machine = SimplyStated::StateMachine.new(&block)
        end

        # see SimplyStated::StateMachine#states
        def self.states(*args)
          @@state_machine.states(*args)
        end

        # see SimplyStated::StateMachine#initial
        def self.initial
          @@state_machine.initial
        end
      }
    end

    def initialize # :nodoc:
      @state = @@state_machine.initial
    end

    # Returns the state the machine is currently in
    def state
      @state
    end

    def method_missing(method_name, *args) # :nodoc:
      if transition = @state.transitions(method_name)
        if ! transition.callback || transition.callback.call(self, *args)
          @state.exit.call(self) if @state.exit
          @state = @@state_machine.states(transition.destination)
          @state.enter.call(self) if @state.enter
        end
      else
        super
      end
    end
  end
end
