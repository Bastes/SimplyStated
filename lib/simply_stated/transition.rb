module SimplyStated
  class Transition
    attr_reader :message, :destination, :callback

    def initialize(message, destination, &callback)
      @message = message
      @destination = destination
      @callback = callback if block_given?
    end
  end
end
