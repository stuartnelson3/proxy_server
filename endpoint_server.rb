require 'socket'
puts "server started on port 9000"
server = TCPServer.new 9000

loop do
  socket = server.accept
  socket.write "\n ### BOUNCED BACK FROM ENDPOINT SERVER ###\n\n"
  socket.flush
  message = socket.gets
  socket.write message
  puts message
  socket.close
end

trap('INT') { acceptor.close }
