require 'socket'

client = TCPSocket.new 'localhost', 3338
client.gets
while true
  client.gets
  answer = gets
  client.puts answer
  client.gets
  answer = gets
  client.puts answer
end
