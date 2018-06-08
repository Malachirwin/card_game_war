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

  def accept_new_client
    client = @server.accept_nonblock
    @pending_clients.push(client)
    if @pending_clients.size.odd?
      client.puts "Welcome, waiting for opponent. you are player 1\n"
    else
      client.puts "Welcome, the game will start soon. you are player 2\n"
    end
  rescue IO::WaitReadable, Errno::EINTR
    puts "No client to accept"
    sleep(2)
  end

  def create_game_if_possible
    if @pending_clients.size > 1
      game = WarGame.new
      game.start
      @games.store(game, @pending_clients.shift(2))
      return game
    else
      return false
    end
  end

  def if_yes(client)
      client = 'yes'
  end


  def ready_to_play_next_round(game)
    client1_input = ''
    client2_input = ''
    until client1_input == "yes\n" && client2_input == "yes\n"
      if client1_input == ''
        client1_input = capture_output(game, 0)
      end
      if client2_input == ''
        client2_input = capture_output(game, 1)
      end
    end
    true
  end

  def games(game_id)
    @games.values[game_id]
  end

  def find_game(game)
    @games.keys[game]
  end

  def find_client_name(game_id, client_id)
    @games.values[game_id][client_id]
  end

  def set_player_hand(game_id, cards, player)
    game = find_game(game_id)
    if player == 'player1'
      game.player1.set_hand(cards)
    else
      game.player2.set_hand(cards)
    end
  end

  def client_winner?(game_id)
    game = find_game(game_id)
    if game.winner
      game.winner.name
    end
  end

  def cards_in_hands(game_id)
    game = find_game(game_id)
    client1 = find_client_name(game_id, 0)
    client2 = find_client_name(game_id, 1)
    client1.puts "You have #{game.player1.cards_left} cards left in your hand."
    client2.puts "You have #{game.player2.cards_left} cards left in your hand."
  end

  def run_game(game)
    game_id = @games.keys.index(game)
    inform_clients_ready(game_id)
    ready_to_play_next_round(game)
    until client_winner?(game_id)
      inform_clients_ready_to_play_round(game_id)
      ready_to_play_next_round(game)
      run_round(game_id)
      cards_in_hands(game_id)
    end
    end_game(game_id)
  end

  def inform_clients_ready(game_id)
    find_client_name(game_id, 0).puts "Your Game is starting, Are you ready?\n"
    find_client_name(game_id, 1).puts "Your Game is starting, Are you ready?\n"
  end

  def inform_clients_ready_to_play_round(game_id)
    find_client_name(game_id, 0).puts "Are you ready to play the next round?\n"
    find_client_name(game_id, 1).puts "Are you ready to play the next round?\n"
  end

  def end_game(game_id)
    find_client_name(game_id, 0).puts "The game has been completed!"
    find_client_name(game_id, 1).puts "The game has been completed!"
  end

  def game_end_options(game_id)
    find_client_name(game_id, 0).puts "Do you want to play another game?\n"
    find_client_name(game_id, 1).puts "Do you want to play another game?\n"
  end

  def run_round(game_id)
    game = find_game(game_id)
    client1 = find_client_name(game_id, 0)
    client2 = find_client_name(game_id, 1)
    result = game.play_round
    client1.puts result
    client2.puts result
  end

  def stop
    @server.close if @server
  end

  private
  def capture_output(delay=0.1, game, wanted_client)
    sleep(delay)
    client = @games[game][wanted_client]
    output = client.read_nonblock(1000)
  rescue IO::WaitReadable
    output = ""
  end
end
