module SimplyStated
  class Transition
    attr_reader :message, :destination

    def initialize(message, destination)
      @message = message
      @destination = destination
    end
  end
end
