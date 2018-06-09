require 'socket'

while true
  begin
    client = TCPSocket.new '10.0.0.150', 3338
    client.gets
    client.gets
    client.puts "yes\n"
    while true
      ask = client.gets
      if ask == "The game has been completed!\n"
        client.gets
        break
      end
      client.puts "yes\n"
      client.gets
      client.gets
    end
  rescue Errno::ECONNREFUSED
    puts "Waiting for server to start..."
    sleep(3)
  rescue Errno::EPIPE
    puts "The server was shut down"
  rescue Errno::ECONNRESET
    puts "Sorry you were disconnected we will try to re connect you soon"
  rescue EOFError
    puts "Game Over"
  end
end



# def run_game(game)
#   game_id = @games.keys.index(game)
#   inform_clients_ready(game_id)
#   ready_to_play_next_round(game)
#   until client_winner?(game_id)
#     inform_clients_ready_to_play_round(game_id)
#     ready_to_play_next_round(game)
#     run_round(game_id)
#     cards_in_hands(game_id)
#   end
#   end_game(game_id)
# end
