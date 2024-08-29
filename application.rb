require_relative './config.rb'
require_relative './logs/logger_config.rb'
require_relative './lib/file_system.rb'

puts "Inicializando memoria cache..."
set_cache()
sleep 3

start_app()
