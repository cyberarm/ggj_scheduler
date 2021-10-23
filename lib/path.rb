class SchedulerGame
  class Path
    attr_reader :map, :valid_types, :nodes

    def initialize(map:, valid_types: [:floor])
      @map = map
      @valid_types = valid_types

      @nodes = []
    end

    def draw
      Gosu.scale(@map.scaler, @map.scaler) do
        @nodes.each do |node|
          Gosu.draw_rect(
            node.position.x * Map::TILE_SIZE,
            node.position.y * Map::TILE_SIZE,
            Map::TILE_SIZE,
            Map::TILE_SIZE,
            valid? ? 0x88_ffffff : 0x88_800000
          )
        end
      end
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
      @nodes.select { |node| valid_types.include?(node.type) }.size == @nodes.size
    end
  end
end
