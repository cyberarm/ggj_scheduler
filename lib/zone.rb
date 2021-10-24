class SchedulerGame
  class Zone
    attr_reader :type, :nodes

    def initialize(type:, nodes:)
      @type = type
      @nodes = nodes.freeze
    end

    def update
    end

    def capacity
      case @type
      when :pit
        4
      when :field
        9
      when :team_queue
        8
      when :audience
        140
      else
        raise NotImplementedError
      end
    end
  end
end
