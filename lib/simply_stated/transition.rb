module SimplyStated
  # =Transition
  #
  # This class presents a transition from a state to another
  class Transition
    # message identifying this transition in the state's context
    attr_reader :message
    # name of the destination state for this transition
    attr_reader :destination
    # callback triggered when this transition is attempted ;
    # return false to prevent transition
    attr_reader :callback

    # Creating a new transition, an identifying message is required (unique for
    # the state), and the name of the destination state.
    #
    # The optional block will provide a callback triggered when the transition
    # is triggered by the machine, and receives the machine's instance as first
    # argument, and optionnaly other arguments provided by the transition call.
    def initialize(message, destination, &callback) # :yields: machine_instance, *args
      @message = message
      @destination = destination
      @callback = callback if block_given?
    end
  end
end
