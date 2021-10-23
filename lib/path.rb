class SchedulerGame
  class Path
    attr_reader :map, :valid_types

    def initialize(map:, valid_types: [:floor])
      @map = map
      @valid_types = valid_types

      @nodes = []
    end

    def add(x, y)
      node = @map.get(x, y)

      @nodes << node

      @nodes
    end

    def remove(x, y)
      @nodes.delete_if { |node| node.x == x && node.y == y }

      @nodes
    end

    def valid?
      false
    end
  end
end
