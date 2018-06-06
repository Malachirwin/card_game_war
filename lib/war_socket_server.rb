require 'socket'
require_relative 'player'
require_relative 'card_deck'
require_relative 'war_round'
require_relative 'card'
require_relative 'war_game'

class WarSocketServer
  attr_reader :player1, :player2

  def initialize
    @games = {}
    @pending_clients = []
  end

  def port_number
    3338
  end

  def games_count
    @games.count
  end

  def start
    @server = TCPServer.new(port_number)
  end

  def accept_new_client(player_name)
    client = [player_name, @server.accept_nonblock]
    @pending_clients.push(client)
    if @pending_clients.size.odd?
      client[1].puts "Welcome, waiting for opponent.\n"
    else
      client[1].puts "Welcome, the game will start soon.\n"
    end
  rescue IO::WaitReadable, Errno::EINTR
    puts "No client to accept"
  end

  def create_game_if_possible
    if @pending_clients.size > 1
      game = WarGame.new
      game.start
      @games.store(game, @pending_clients.shift(2))
    end
  end

  def ready_to_play_next_round(delay=0.1, game_id)
    sleep(delay)
    players_array = @games.values[game_id]
    if players_array[0][1].read_nonblock(1000).chomp == 'yes' || players_array[1][1].read_nonblock(1000).chomp == 'yes'
      return true
    end
  rescue IO::WaitReadable
    return false
  end

  def games(game_id)
    @games.values[game_id]
  end

  def find_game(game)
    @games.keys[game]
  end

  def find_client_name(game_id, client_id)
    client = @games.values[game_id][client_id][0]
  end

  def set_player_hand(game_id, cards, player)
    game = find_game(game_id)
    if player == 'player1'
      game.player1.set_hand(cards)
    else
      game.player2.set_hand(cards)
    end
  end

  def run_round(game_id)
    game = @games.keys[game_id]
    player1 = @games.values[game_id][0][1]
    player2 = @games.values[game_id][1][1]
    result = game.play_round
    player1.puts result
    player2.puts result
  end

  def stop
    @server.close if @server
  end

end
