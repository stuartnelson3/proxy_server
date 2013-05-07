require 'socket'
puts "server started on port 9000"
server = TCPServer.new 9000

socket, addr = server.accept
puts "connection made!#{addr}"
loop do
  socket.write "\n ### BOUNCED BACK FROM ENDPOINT SERVER ###\n\n"
  socket.flush
  message = socket.gets
  socket.write message
  puts message
end

trap('INT') { acceptor.close }
