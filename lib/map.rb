class SchedulerGame
  class Map
    include CyberarmEngine::Common

    TILE_SIZE = 16

    TILE_TYPES = {
      "#" => :wall,
      " " => :floor,
      "F" => :field,
      "P" => :pit,
      "D" => :entry_door,
      "I" => :competition_inlet,
      "O" => :competition_outlet,
      "Q" => :team_queue,
      "A" => :audience,
    }

    TILE_COLORS = {
      floor: Gosu::Color::BLACK,
      wall: Gosu::Color::GRAY,
      field: Gosu::Color::GRAY,
      entry_door: Gosu::Color::CYAN,
      pit: Gosu::Color::WHITE,
      audience: Gosu::Color::YELLOW,
      team_queue: Gosu::Color::BLUE,
      competition_inlet: Gosu::Color::RED,
      competition_outlet: Gosu::Color::GREEN,
    }

    def initialize(file:)
      @file = File.read(file)

      @grid = []
      @zones = []

      parse
      parse_zones

      @scaler = [window.width / (@width.to_f * TILE_SIZE), window.height / (@height.to_f * TILE_SIZE)].min
    end

    def parse
      y = 0

      @file.each_line do |line|
        x = 0
        line.strip.chars do |char|
          @grid << Node.new(
            position: CyberarmEngine::Vector.new(x, y, 0),
            type: parse_char(char),
            color: tile_color(parse_char(char))
          )

          x += 1
        end

        y += 1

        @width  = x
        @height = y
      end
    end

    def parse_zones
      clone = nodes.clone

      clone.reject { |n| %i[wall floor].include?(n.type) }.each do |node|
        _nodes = floodfill_select(node, node.type)

        @zones << Zone.new(type: node.type, nodes: _nodes)

        clone.delete(_nodes)
      end
    end

    def parse_char(char)
      TILE_TYPES[char] || raise("No parser for: #{char.inspect}")
    end

    def tile_color(type)
      TILE_COLORS[type] || raise("No color for: #{type.inspect}")
    end

    def draw
      Gosu.scale(@scaler, @scaler) do
        @height.times do |y|
          @width.times do |x|
            Gosu.draw_rect(
              x * TILE_SIZE,
              y * TILE_SIZE,
              TILE_SIZE,
              TILE_SIZE,
              get(x, y).color,
              0
            )
          end
        end
      end
    end

    def update
      @scaler = [window.width / (@width.to_f * TILE_SIZE), window.height / (@height.to_f * TILE_SIZE)].min
    end

    def get(x, y)
      @grid[y * @width + x]
    end

    def set(x, y, value)
      @grid[y * @width + x] = value
    end

    def mouse_over(x, y)
      x /= @scaler
      y /= @scaler

      x /= TILE_SIZE
      y /= TILE_SIZE

      get(x.floor.clamp(0..@width - 1), y.floor.clamp(0..@height - 1))
    end

    def nodes
      @grid
    end

    def scaler
      @scaler
    end

    def floodfill_select(node, type, list = [])
      return unless node
      return if list.include?(node)
      return if node.type != type

      list << node

      # UP
      floodfill_select(get(node.position.x, node.position.y - 1), type, list)

      # DOWN
      floodfill_select(get(node.position.x, node.position.y + 1), type, list)

      # LEFT
      floodfill_select(get(node.position.x - 1, node.position.y), type, list)

      # RIGHT
      floodfill_select(get(node.position.x + 1, node.position.y), type, list)

      list
    end
  end
end
