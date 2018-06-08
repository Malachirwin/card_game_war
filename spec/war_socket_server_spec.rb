require 'socket'
require 'war_socket_server'
require 'rspec'
require 'pry'

class MockWarSocketClient
  attr_reader :socket
  attr_reader :output
  attr_reader :sockets

  def initialize(port)
    if @sockets
    else
      @sockets = []
    end
    @socket = TCPSocket.new('localhost', port)
    @sockets.push(@socket)
  end

  def provide_input(text)
    @socket.puts(text)
  end

  def capture_output(delay=0.1)
    sleep(delay)
    @output = @socket.read_nonblock(1000)
  rescue IO::WaitReadable
    @output = ""
  end

  def close
    @socket.close if @socket
  end
end

describe WarSocketServer do
  before(:each) do
    @clients = []
    @server = WarSocketServer.new
  end

  after(:each) do
    @server.stop
    @clients.each do |client|
      client.close
    end
  end

  it "is not listening on a port before it is started"  do
    expect {MockWarSocketClient.new(@server.port_number)}.to raise_error(Errno::ECONNREFUSED)
  end
  it "accepts new clients and starts a game if possible" do
    @server.start
    client1 =MockWarSocketClient.new(@server.port_number)
    @server.accept_new_client
    @server.create_game_if_possible
    expect(@server.games_count).to be 0
    client2 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client2)
    @server.accept_new_client
    @server.create_game_if_possible
    expect(@server.games_count).to be 1
  end

  it "make sure mock player gets the right message" do
    @server.start
    client1 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client1)
    @server.accept_new_client
    expect(client1.capture_output).to eq "Welcome, waiting for opponent. you are player 1\n"
    client2 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client2)
    @server.accept_new_client
    @server.create_game_if_possible
    expect(client2.capture_output).to eq "Welcome, the game will start soon. you are player 2\n"
    client3 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client3)
    @server.accept_new_client
    @server.create_game_if_possible
    expect(client3.capture_output).to eq "Welcome, waiting for opponent. you are player 1\n"
  end

  it "sees if players are ready" do
    game_id = 0
    @server.start
    client1 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client1)
    @server.accept_new_client
    client2 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client2)
    @server.accept_new_client
    @server.create_game_if_possible
  end

  context 'war game' do
    before(:each) do
      @clients = []
      @server = WarSocketServer.new
      @server.start
      client1 = MockWarSocketClient.new(@server.port_number)
      @client1 = client1
      @clients.push(client1)
      @server.accept_new_client
      client2 = MockWarSocketClient.new(@server.port_number)
      @client2 = client2
      @clients.push(client2)
      @server.accept_new_client
      @server.create_game_if_possible
      client3 = MockWarSocketClient.new(@server.port_number)
      @client3 = client3
      @clients.push(client3)
      @server.accept_new_client
      client4 = MockWarSocketClient.new(@server.port_number)
      @client4 = client4
      @clients.push(client4)
      @server.accept_new_client
      @server.create_game_if_possible
    end

    after(:each) do
      @server.stop
      @clients.each do |client|
        client.close
      end
    end

    it 'informs players game is starting' do
      game_id = 0
      @server.create_game_if_possible
      @client1.capture_output
      @client2.capture_output
      @server.inform_clients_ready(game_id)
      expect(@client1.capture_output).to eq "Your Game is starting, Are you ready?\n"
      expect(@client2.capture_output).to eq "Your Game is starting, Are you ready?\n"
    end

    it 'informs players game ended' do
      game_id = 0
      @server.create_game_if_possible
      @client1.capture_output
      @client2.capture_output
      @server.end_game(game_id)
      expect(@client1.capture_output).to eq "The game has been completed!\n"
      expect(@client2.capture_output).to eq "The game has been completed!\n"
    end

    it 'plays a round of war with two clients' do
      first_game_id = 0
      @client1.capture_output
      @client2.capture_output
      game = @server.games(first_game_id)
      @server.find_game(first_game_id)
      @server.set_player_hand(first_game_id, [Card.new("D", 9)], "player1")
      @server.set_player_hand(first_game_id, [Card.new("H", 6)], "player2")
      @server.run_round(first_game_id)
      expect(@client1.capture_output).to eq "player 1 took 7 of Hearts with 10 of Diamonds\n"
      expect(@client2.capture_output).to eq "player 1 took 7 of Hearts with 10 of Diamonds\n"
    end

    it 'plays a couple round of war with two clients' do
      first_game_id = 0
      @client1.capture_output
      @client2.capture_output
      game = @server.games(first_game_id)
      @server.find_game(first_game_id)
      @server.set_player_hand(first_game_id, [Card.new("D", 9), Card.new("D", 4), Card.new("D", 6)], "player1")
      @server.set_player_hand(first_game_id, [Card.new("H", 6), Card.new("H", 1), Card.new("H", 7)], "player2")
      @server.run_round(first_game_id)
      expect(@client1.capture_output).to eq "player 1 took 7 of Hearts with 10 of Diamonds\n"
      expect(@client2.capture_output).to eq "player 1 took 7 of Hearts with 10 of Diamonds\n"
      @server.run_round(first_game_id)
      expect(@client1.capture_output).to eq "player 1 took 2 of Hearts with 5 of Diamonds\n"
      expect(@client2.capture_output).to eq "player 1 took 2 of Hearts with 5 of Diamonds\n"
      @server.run_round(first_game_id)
      expect(@client1.capture_output).to eq "player 2 took 7 of Diamonds with 8 of Hearts\n"
      expect(@client2.capture_output).to eq "player 2 took 7 of Diamonds with 8 of Hearts\n"
    end

    it 'returns the players card count of the first game' do
      game = 0
      @server.create_game_if_possible
      @client1.capture_output
      @server.cards_in_hands(game)
      expect(@client1.capture_output).to eq ("You have 26 cards left in your hand.\n")
    end

    it 'tests end game' do
      @server.create_game_if_possible
      @client1.capture_output
      @client2.capture_output
      game_id = 0
      @server.end_game(game_id)
      expect(@client1.capture_output).to eq ("The game has been completed!\n")
      expect(@client2.capture_output).to eq ("The game has been completed!\n")
    end

    it 'tests if clients are ready to play nexxt round' do
      @server.create_game_if_possible
      @client1.capture_output
      @client2.capture_output
      game_id = 0
      @server.end_game(game_id)
      @client1.capture_output
      @client2.capture_output
      @server.inform_clients_ready_to_play_round(game_id)
      expect(@client1.capture_output).to eq ("Are you ready to play the next round?\n")
      expect(@client2.capture_output).to eq ("Are you ready to play the next round?\n")
    end

    it 'tests end game if client wants to play agian' do
      @server.create_game_if_possible
      @client1.capture_output
      @client2.capture_output
      game_id = 0
      @server.end_game(game_id)
      @client1.capture_output
      @client2.capture_output
      @server.game_end_options(game_id)
      expect(@client1.capture_output).to eq ("Do you want to play another game?\n")
      expect(@client2.capture_output).to eq ("Do you want to play another game?\n")
    end

    it 'sees if clients are ready to play' do
      game_id = 2
      @server.create_game_if_possible
      client5 = MockWarSocketClient.new(@server.port_number)
      @server.accept_new_client
      client6 = MockWarSocketClient.new(@server.port_number)
      @server.accept_new_client
      client5.provide_input"yes"
      client6.provide_input "yes"
      game = @server.create_game_if_possible
      expect(@server.ready_to_play_next_round(game)).to eq(true)
    end

    it 'Sees if there is a winner' do
      @server.create_game_if_possible
      @client1.capture_output
      @client2.capture_output
      game_id = 0
      @server.set_player_hand(game_id, [Card.new("D", 9)], "player1")
      @server.set_player_hand(game_id, [Card.new("H", 6)], "player2")
      @server.run_round(game_id)
      expect(@server.client_winner?(game_id)).to eq 'player1'
    end

  end

  # Add more tests to make sure the game is being played
  # For example:
  #   make sure the mock client gets appropriate output
  #   make sure the next round isn't played until both clients say they are ready to play
  #   ...
end
