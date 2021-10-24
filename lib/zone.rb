class SchedulerGame
  class Zone
    include CyberarmEngine::Common

    attr_reader :map, :type, :nodes

    def initialize(map:, type:, nodes:)
      @map = map
      @type = type
      @nodes = nodes.freeze

      @mode = :receiving

      @receiving_image = window.get_image("#{GAME_ROOT_PATH}/media/receiving.png")
      @sending_image = window.get_image("#{GAME_ROOT_PATH}/media/sending.png")
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
        4
      when :audience
        140
      when :entry_door
        Float::INFINITY
      else
        raise NotImplementedError
      end
    end

    def occupancy
      @map.travellers.select { |t| t.zone == self }.count
    end
  end
end
