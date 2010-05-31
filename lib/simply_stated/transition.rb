module SimplyStated
  class Transition
    attr_reader :message, :to_state

    def initialize(message, to_state)
      @message = message
      @to_state = to_state
    end
  end
end
