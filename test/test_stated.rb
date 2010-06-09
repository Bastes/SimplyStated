require 'helper'

class TestStated < Test::Unit::TestCase
  context("A simple machine with two states and one transition each") {
    setup {
      @machine_class = Class.new {
        include SimplyStated::Stated
        describe_states { |m|
          m.state(:initial) { |s|
            s.transition :goto_other, :other
          }
          m.state(:other) { |s|
            s.transition :goto_initial, :initial
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
  context("A simple machine with transition callbacks") {
    setup {
      @transition_hook = transition_hook = lambda { |m, *n|
        n = n.first || 1
        if n > 0
          m.passed += n
        else
          false
        end
      }
      @machine_class = Class.new {
        include SimplyStated::Stated
        attr_accessor :passed

        def initialize
          super
          @passed = 0
        end

        describe_states { |d|
          d.state(:initial) { |s|
            s.transition(:goto_other, :other, &transition_hook)
          }
          d.state(:other) { |s|
            s.transition(:goto_initial, :initial, &transition_hook)
          }
        }
      }
      @machine_instance = @machine_class.new
    }
    should("keep the callbacks") {
      @machine_class.states.collect { |state| state.transitions }.flatten.each { |transition|
        assert_equal @transition_hook, transition.callback
      }
    }
    should("execute the callback on each transition") {
      assert_equal :initial, @machine_instance.state.name
      assert_equal 0, @machine_instance.passed
      @machine_instance.goto_other
      assert_equal :other, @machine_instance.state.name
      assert_equal 1, @machine_instance.passed
    }
    should("accept arguments on transitions calls") {
      assert_equal :initial, @machine_instance.state.name
      assert_equal 0, @machine_instance.passed
      @machine_instance.goto_other 2
      assert_equal :other, @machine_instance.state.name
      assert_equal 2, @machine_instance.passed
    }
    should("stay on state when callback returns false") {
      assert_equal :initial, @machine_instance.state.name
      assert_equal 0, @machine_instance.passed
      @machine_instance.goto_other -1
      assert_equal :initial, @machine_instance.state.name
      assert_equal 0, @machine_instance.passed
    }
  }
  context("A simple machine with state enter callbacks") {
    setup {
      @enter_hook = enter_hook = lambda { |m|
        m.passed += 1
      }
      @machine_class = Class.new {
        include SimplyStated::Stated
        attr_accessor :passed

        def initialize
          super
          @passed = 0
        end

        describe_states { |d|
          d.state(:initial, :enter => enter_hook) { |s|
            s.transition(:goto_other, :other)
          }
          d.state(:other, :enter => enter_hook) { |s|
            s.transition(:goto_initial, :initial)
          }
        }
      }
      @machine_instance = @machine_class.new
    }
    should("not execute the callback when entering the initial state for the first time") {
      assert_equal :initial, @machine_instance.state.name
      assert_equal 0, @machine_instance.passed
    }
    should("execute the callback when entering states") {
      assert_equal :initial, @machine_instance.state.name
      assert_equal 0, @machine_instance.passed
      @machine_instance.goto_other
      assert_equal :other, @machine_instance.state.name
      assert_equal 1, @machine_instance.passed
    }
  }
end
