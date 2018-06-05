require 'socket'
require_relative 'player'
require_relative 'card_deck'
require_relative 'war_round'
require_relative 'card'

class WarSocketServer
  attr_reader :player1, :player2
  def initialize
    @games = []
    @player1 = "available"
  end

  def port_number
    3336
  end

  def games
    @games
  end

  def start
    @server = TCPServer.new(port_number)
  end

  def accept_new_client(player_name)
    if @player1 == "available"
      @player1 = @server.accept_nonblock
    else
      @player2 = @server.accept_nonblock
    end
  rescue IO::WaitReadable, Errno::EINTR
    puts "No client to accept"
  end

  def prepare_player
    @player1.puts "Are you ready to play war?"
    @player2.puts "Are you ready to play war?"
  end

  def create_game_if_possible(clients)
    if clients.count == 2
      @games.push('new_game')
    else
      puts 'waiting for other player to join'
    end
  end

  def ready_to_play_next_round(delay=0.1)
    sleep(delay)
    if @player1.read_nonblock(1000).chomp == 'yes' || @player2.read_nonblock(1000).chomp == 'yes'
      return true
    end
  rescue IO::WaitReadable
    return false
  end

  def stop 
    @server.close if @server
  end
end
