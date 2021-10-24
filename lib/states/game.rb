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

        @paths = []

        @key_history = Array.new(KONAMI_CODE.size, 0)
        @key_history_index = 0

        @font = Gosu::Font.new(28)
      end

      def draw
        fill(0xf88_444444)
        @map.draw

        @paths.each(&:draw)

        @font.draw_text(@map.mouse_over(window.mouse_x, window.mouse_y).type, window.mouse_x + 12 + 2, window.mouse_y + 2, 5, 1, 1, Gosu::Color::BLACK)
        @font.draw_text(@map.mouse_over(window.mouse_x, window.mouse_y).type, window.mouse_x + 12, window.mouse_y, 5)
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
        @building_path = true

        @paths << Path.new(map: @map)
      end

      def add_to_path
        node = @map.mouse_over(window.mouse_x, window.mouse_y)

        @paths.last.nodes << node if node != @paths.last&.nodes&.detect { |n| n == node } &&
                                     node_is_straight?(node, @paths.last&.nodes&.last) &&
                                     node_is_neighbor?(node, @paths.last&.nodes&.last)

        @paths.last.externally_valid = path_valid?(@paths.last)
      end

      def finish_path
        @building_path = false

        unless @paths.last&.valid?
          @paths.delete(@paths.last)
        end
      end

      def path_valid?(path_a)
        @paths.reject { |o| o == path_a }.each do |path_b|
          return false if path_a.nodes.any? { |n| path_b.nodes.include?(n) }
        end

        true
      end

      def node_is_straight?(a, b)
        return true if b.nil?

        norm = (a.position - b.position).normalized


        norm.x.round(1).abs == 1.0 && norm.y.round(1).abs == 0.0 ||
        norm.x.round(1).abs == 0.0 && norm.y.round(1).abs == 1.0
      end

      def node_is_neighbor?(a, b)
        return true if b.nil?

        a.position.distance(b.position) <= 1.0
      end
    end
  end
end
