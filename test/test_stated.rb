require 'helper'

class TestStated < Test::Unit::TestCase
  context("A simple machine with two states and one transition each") {
    setup {
      @machine_class = Class.new {
        include SimplyStated::Stated
        states {
          state(:initial) {
            transition :goto_other, :other
          }
          state(:other) {
            transition :goto_initial, :initial
          }
        }
      }
      @machine_instance = @machine_class.new
    }
    should("start with the first state described by default") {
      assert_equal @machine_instance.state.name, :initial
    }
  }
end
