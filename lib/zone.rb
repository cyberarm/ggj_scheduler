class SchedulerGame
  class Zone
    attr_reader :type, :nodes

    def initialize(type:, nodes:)
      @type = type
      @nodes = nodes.freeze
    end

    def update
    end
  end
end
