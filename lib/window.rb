class SchedulerGame
  class Window < CyberarmEngine::Window
    def setup
      push_state(SchedulerGame::States::MainMenu)
      # push_state(SchedulerGame::States::GameLost)
      # push_state(SchedulerGame::States::GameWon)
      # push_state(SchedulerGame::States::Game)

      self.caption = "Scheduler"
    end

    def button_down(id)
      super

      close if id == Gosu::KB_ESCAPE unless @states.first.is_a?(States::MainMenu)
    end
  end
end
