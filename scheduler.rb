require "cyberarm_engine"

GAME_ROOT_PATH = File.expand_path(".", __dir__)

require_relative "lib/window"
require_relative "lib/node"
require_relative "lib/path"
require_relative "lib/zone"
require_relative "lib/map"
require_relative "lib/states/main_menu"
require_relative "lib/states/game"

SchedulerGame::Window.new(width: 1280, height: 720, resizable: true).show
