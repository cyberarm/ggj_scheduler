class SchedulerGame
  class States
    class Game < CyberarmEngine::GuiState
      KONAMI_CODE = [
        Gosu::KB_UP,
        Gosu::KB_UP,
        Gosu::KB_DOWN,
        Gosu::KB_DOWN,
        Gosu::KB_LEFT,
        Gosu::KB_RIGHT,
        Gosu::KB_LEFT,
        Gosu::KB_RIGHT,
        Gosu::KB_B,
        Gosu::KB_A,
      ]

      def setup
        window.show_cursor = true

        @map = Map.new(file: "#{GAME_ROOT_PATH}/media/maps/1.dat")

        @key_history = Array.new(KONAMI_CODE.size, 0)
        @key_history_index = 0

        @font = Gosu::Font.new(28)
      end

      def draw
        fill(0xf88_444444)
        @map.draw

        @map.paths.each(&:draw)
      end

      def update
        @map.update

        add_to_path if @building_path
      end

      def button_down(id)
        super

        # TODO: Track mouse move while button down to create path to NEED #
        construct_path if id == Gosu::MS_LEFT

        @key_history[@key_history_index] = id

        if @key_history == KONAMI_CODE
          window.close

          puts "You cheated! [TODO: Maybe do something fun?]"
        end

        @key_history_index += 1

        if @key_history_index > @key_history.size - 1
          @key_history_index = 0
          @key_history = Array.new(@key_history.size, 0)
        end
      end

      def button_up(id)
        super

        finish_path if id == Gosu::MS_LEFT
      end

      def construct_path
        node = @map.mouse_over(window.mouse_x, window.mouse_y)

        return unless node_neighbor_is_zone?(node)

        @building_path = true

        @map.paths << Path.new(map: @map, color_index: Path.next_color)
      end

      def add_to_path
        node = @map.mouse_over(window.mouse_x, window.mouse_y)

        @map.paths.last.nodes << node if node != @map.paths.last&.nodes&.detect { |n| n == node } &&
                                     node_is_straight?(node, @map.paths.last&.nodes&.last) &&
                                     node_is_neighbor?(node, @map.paths.last&.nodes&.last) &&
                                     node.type == :floor

        @map.paths.last.externally_valid = path_valid?(@map.paths.last)
      end

      def finish_path
        @building_path = false

        unless @map.paths.last&.valid? &&
               node_neighbor_is_zone?(@map.paths.last&.nodes&.last) &&
               node_neighbor_is_zone?(@map.paths.last&.nodes&.first) != node_neighbor_is_zone?(@map.paths.last&.nodes&.last)

          @map.paths.delete(@map.paths.last)
        else
          @map.paths.last.building = false
          assign_path(@map.paths.last)
        end
      end

      def path_valid?(path_a)
        @map.paths.reject { |o| o == path_a }.each do |path_b|
          return false if path_a.nodes.any? { |n| path_b.nodes.include?(n) }
        end

        true
      end

      def assign_path(path)
        zone = node_neighbor_is_zone?(path.nodes.first)
        goal = node_neighbor_is_zone?(path.nodes.last)

        travellers = @map.travellers.select { |t| t.path.nil? && t.zone == zone && t.goal == goal }

        if travellers.size.positive?
          travellers.each { |t| t.path = path }
        else
          @map.paths.delete(path)
        end
      end

      def node_is_straight?(a, b)
        return true if b.nil?

        norm = (a.position - b.position).normalized

        # Round to 1 decimal place to correct for floating point error
        norm.x.round(1).abs == 1.0 && norm.y.round(1).abs == 0.0 ||
        norm.x.round(1).abs == 0.0 && norm.y.round(1).abs == 1.0
      end

      def node_is_neighbor?(a, b)
        return true if b.nil?

        a.position.distance(b.position) <= 1.0
      end

      def node_neighbor_is_zone?(node)
        return false unless node

        # UP
        up = @map.get_zone(node.position.x, node.position.y - 1)
        return up if up

        # DOWN
        down = @map.get_zone(node.position.x, node.position.y + 1)
        return down if down

        # LEFT
        left = @map.get_zone(node.position.x - 1, node.position.y)
        return left if left

        # RIGHT
        right = @map.get_zone(node.position.x + 1, node.position.y)
        return right if right

        false
      end
    end
  end
end
