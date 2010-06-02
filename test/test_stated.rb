require 'helper'

class TestStated < Test::Unit::TestCase
  context("A simple machine with two states and one transition each") {
    setup {
      @machine_class = Class.new {
        include SimplyStated::Stated
        describe_states {
          state(:initial) {
            transition :goto_other, :other
          }
          state(:other) {
            transition :goto_initial, :initial
          }
        }
      }
    }
    should("have the two states described and their transitions") {
      assert_equal 2, @machine_class.states.length
      { :initial => { :goto_other => :other },
        :other => { :goto_initial => :initial } }.each { |name, transitions|
        state = @machine_class.states(name)
        assert state
        transitions.each { |message, destination|
          transition = state.transitions(message)
          assert transition
          assert_equal destination, transition.destination
        }
      }
    }

    context(", once instanciated") {
      setup { @machine_instance = @machine_class.new }
      should("start with the first state described by default") {
        assert_equal :initial, @machine_instance.state.name
      }
      should("change state given the right message") {
        @machine_instance.goto_other
        assert_equal :other, @machine_instance.state.name
        @machine_instance.goto_initial
        assert_equal :initial, @machine_instance.state.name
      }
      should("not accept messages for another state") {
        assert_raise(NoMethodError) { @machine_instance.goto_initial }
        assert_equal :initial, @machine_instance.state.name
      }
    }
  }
end
