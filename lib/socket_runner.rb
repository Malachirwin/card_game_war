require 'socket'
require_relative 'war_socket_server'
require 'pry'

server = WarSocketServer.new
server.start
loop do
  server.accept_new_client
  game = server.create_game_if_possible
  if game
    Thread.new { server.run_game(game) }
  end
rescue EOFError
  puts 'game has ended'
rescue
  server.stop
end
