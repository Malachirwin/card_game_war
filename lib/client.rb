require 'socket'
require 'pry'

please_end = 'no'

while true
  begin
    client = TCPSocket.new '10.0.0.150', 3338
    puts client.gets
    puts client.gets
    answer = ""
    until answer == "yes\n"
      answer = gets.downcase
    end
    client.puts answer
    while true
      ask = client.gets
      puts ask
      if ask == "The game has been completed!\n"
        puts client.gets
        answer = gets.downcase
        if answer == "yes\n"
          break
        else
          please_end = 'yes'
          break
        end
      end
      answer = ''
      until answer == "yes\n"
        answer = gets.downcase
      end
      client.puts answer
      puts client.gets
      puts client.gets
    end
  rescue Errno::ECONNREFUSED
    puts "Waiting for server to start..."
    sleep(3)
  rescue Errno::EPIPE
    puts "The server was shut down"
  rescue Errno::ECONNRESET
    puts "Sorry the server was shut down."
  rescue EOFError
    puts "Game Over"
    break
  end
  if please_end == 'yes'
    break
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
