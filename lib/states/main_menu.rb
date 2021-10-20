class SchedulerGame
  class States
    class MainMenu < CyberarmEngine::GuiState
      def setup
        window.show_cursor = true

        flow(width: 1.0, height: 1.0) do
          stack(width: 0.3, height: 1.0, padding: 24) do
            background 0xff_884400

            banner "SCHEDULER", text_align: :center, width: 1.0

            button "PLAY", width: 1.0 do
              push_state(SchedulerGame::States::Game)
            end

            button "QUIT", width: 1.0 do
              window.close
            end
          end

          stack(width: 0.7, height: 1.0, padding: 24) do
            background 0xff_442200

            title "HOW TO PLAY"

            para "Do the thing and the other thing so that the things go a do the thing without thinging."
          end
        end
      end
    end
  end
end
