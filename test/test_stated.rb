require 'helper'

class TestStated < Test::Unit::TestCase
  context("A simple machine with two states and one transition each") {
    setup {
      @machine_class = Class.new {
        include SimplyStated::Stated
        describe_states { |m|
          m.state(:initial) { |s|
            s.transition :to_other => :other
          }
          m.state(:other) { |s|
            s.transition :to_initial => :initial
          }
        }
      }
      @machine_instance = @machine_class.new
    }
    should("start on the first state as initial state") {
      assert_equal :initial, @machine_instance.state
    }
    should("transition according to the description") {
      @machine_instance.to_other
      assert_equal :other, @machine_instance.state
      @machine_instance.to_initial
      assert_equal :initial, @machine_instance.state
    }
    should("not accept transitions contrary to the description") {
      assert_raise(NoMethodError) { @machine_instance.to_initial }
      @machine_instance.to_other
      assert_equal :other, @machine_instance.state
      assert_raise(NoMethodError) { @machine_instance.to_other }
    }
  }
end
