require 'socket'
require_relative '../lib/war_socket_server'
require_relative '../lib/card'
require 'pry'

class MockWarSocketClient
  attr_reader :socket
  attr_reader :output

  def initialize(port)
    @socket = TCPSocket.new('localhost', port)
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
    client1 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client1)
    @server.accept_new_client("Player 1")
    @server.create_game_if_possible
    expect(@server.games.count).to be 0
    client2 = MockWarSocketClient.new(@server.port_number)
    @clients.push(client2)
    @server.accept_new_client("Player 2")
    @server.create_game_if_possible
    expect(@server.games.count).to be 1
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
    expect(@server.ready_to_play_next_round).to eq false
    client1.provide_input('yes')
    client2.provide_input('yes')
    expect(@server.ready_to_play_next_round).to eq true
  end

  context 'war game' do
    before(:each) do
      @server.start
      client1 = MockWarSocketClient.new(@server.port_number)
      @clients.push(client1)
      @server.accept_new_client("Player1")
      client2 = MockWarSocketClient.new(@server.port_number)
      @clients.push(client2)
      @server.accept_new_client("Player2")
      @server.create_game_if_possible
    end

    it ''
  end

  # Add more tests to make sure the game is being played
  # For example:
  #   make sure the mock client gets appropriate output
  #   make sure the next round isn't played until both clients say they are ready to play
  #   ...
end
