require 'socket'
require 'war_socket_server'
require_relative '../lib/card'
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
    @output = @socket.read_nonblock(1000) # not gets which blocks
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
    @server.accept_new_client("Player 1")
    @server.create_game_if_possible
    expect(@server.games_count).to be 0
    client2 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client2)
    @server.accept_new_client("Player 2")
    @server.create_game_if_possible
    expect(@server.games_count).to be 1
  end

  it "make sure mock player gets the right message" do
    @server.start
    client1 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client1)
    @server.accept_new_client("Player1")
    expect(client1.capture_output).to eq "Welcome, waiting for opponent.\n"
    client2 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client2)
    @server.accept_new_client("Player2")
    @server.create_game_if_possible
    expect(client2.capture_output).to eq "Welcome, the game will start soon.\n"
    client3 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client3)
    @server.accept_new_client("Player2")
    @server.create_game_if_possible
    expect(client3.capture_output).to eq "Welcome, waiting for opponent.\n"
  end

  it "sees if players are ready" do
    @server.start
    client1 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client1)
    @server.accept_new_client("Player1")
    client2 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client2)
    @server.accept_new_client("Player2")
    @server.create_game_if_possible
    expect(@server.ready_to_play_next_round(0)).to eq false
    client1.provide_input('yes')
    client2.provide_input('yes')
    expect(@server.ready_to_play_next_round(0)).to eq true
  end

  context 'war game' do
    before(:each) do
      @clients = []
      @server = WarSocketServer.new
      @server.start
      client1 = MockWarSocketClient.new(@server.port_number)
      @client1 = client1
      @clients.push(client1)
      @server.accept_new_client("Player1")
      client2 = MockWarSocketClient.new(@server.port_number)
      @client2 = client2
      @clients.push(client2)
      @server.accept_new_client("Player2")
      @server.create_game_if_possible
      client3 = MockWarSocketClient.new(@server.port_number)
      @client3 = client3
      @clients.push(client3)
      @server.accept_new_client("Player1")
      client4 = MockWarSocketClient.new(@server.port_number)
      @client4 = client4
      @clients.push(client4)
      @server.accept_new_client("Player2")
      @server.create_game_if_possible
    end

    after(:each) do
      @server.stop
      @clients.each do |client|
        client.close
      end
    end

    it 'make sure the clients get connected to game' do
      game_id = 0
      client_id = 0
      expect(@server.find_client_name(game_id, client_id)).to eq 'Player1'
      client_id = 1
      expect(@server.find_client_name(game_id, client_id)).to eq 'Player2'
    end

    it 'make sure two clients are connected to a game for two games.' do
      game_id = 0
      client_id = 0
      expect(@server.find_client_name(game_id, client_id)).to eq 'Player1'
      client_id = 1
      expect(@server.find_client_name(game_id, client_id)).to eq 'Player2'
      game_id = 1
      client_id = 0
      expect(@server.find_client_name(game_id, client_id)).to eq 'Player1'
      client_id = 1
      expect(@server.find_client_name(game_id, client_id)).to eq 'Player2'
    end

    it 'plays a round of war with two clients' do
      expect(@server.ready_to_play_next_round(0)).to eq false
      @client1.provide_input('yes')
      @client2.provide_input('yes')
      @client1.capture_output
      @client2.capture_output
      expect(@server.ready_to_play_next_round(0)).to eq true
      first_game_id = 0
      game = @server.games(first_game_id)
      @server.find_game(first_game_id)
      @server.set_player_hand(first_game_id, [Card.new("D", 9)], "player1")
      @server.set_player_hand(first_game_id, [Card.new("H", 6)], "player2")
      @server.run_round(first_game_id)
      expect(@client1.capture_output).to eq "player 1 took 7 of Hearts with 10 of Diamonds\n"
      expect(@client2.capture_output).to eq "player 1 took 7 of Hearts with 10 of Diamonds\n"
    end

    it 'plays a couple round of war with two clients' do
      expect(@server.ready_to_play_next_round(0)).to eq false
      @client1.provide_input('yes')
      @client2.provide_input('yes')
      expect(@server.ready_to_play_next_round(0)).to eq true
      @client1.capture_output
      @client2.capture_output
      first_game_id = 0
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
  end

  # Add more tests to make sure the game is being played
  # For example:
  #   make sure the mock client gets appropriate output
  #   make sure the next round isn't played until both clients say they are ready to play
  #   ...
end
