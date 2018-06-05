require 'socket'
require_relative 'player'
require_relative 'card_deck'
require_relative 'war_round'
require_relative 'card'
require_relative 'war_game'

class WarSocketServer

  attr_reader :player1, :player2, :games

  def initialize
    @games = []
    @pending_clients = []
  end

  def port_number
    3337
  end

  def games_count
    @games
  end

  def start
    @server = TCPServer.new(port_number)
  end

  def accept_new_client(player_name)
    client = @server.accept_nonblock
    @pending_clients.push(client)
    if @pending_clients.size.odd?
      client.puts "Welcome, waiting for opponent.\n"
    else
      client.puts "Welcome, the game will start soon.\n"
    end
  rescue IO::WaitReadable, Errno::EINTR
    puts "No client to accept"
  end

  def create_game_if_possible
    if @pending_clients.size > 1
      game = WarGame.new
      game.start
      @games.push(game)
    end
  end

  def ready_to_play_next_round(delay=0.1)
    sleep(delay)
    if @pending_clients[0].read_nonblock(1000).chomp == 'yes' || @pending_clients[1].read_nonblock(1000).chomp == 'yes'
      return true
    end
  rescue IO::WaitReadable
    return false
  end

  def stop
    @server.close if @server
  end

end
