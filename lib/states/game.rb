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

        @font.draw_text(@map.mouse_over(window.mouse_x, window.mouse_y), window.mouse_x + 12 + 2, window.mouse_y + 2, 5, 1, 1, Gosu::Color::BLACK)
        @font.draw_text(@map.mouse_over(window.mouse_x, window.mouse_y), window.mouse_x + 12, window.mouse_y, 5)
      end

      def update
        @map.update
      end

      def button_down(id)
        super

        # TODO: Track mouse move while button down to create path to NEED #

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
    end
  end
end
