require 'socket'

class DataDumper
  def initialize name
    @name = name
    @file = File.open "#{@name << '_' << Time.now.to_s.split[1].gsub(':','_')}.txt", "a"
  end

  def log_data data
    @file.write "\n#{@name.upcase}:\n"
    @file.write "#{data}\n"
  end

  def end_dump
    @file.write "\n\n ### END OF DUMP FROM #@name ### \n\n"
    @file.close
    puts "#@name closed"
  end
end

proxy_server = TCPServer.new 8080
client = proxy_server.accept
puts 'starting server on port 8080'

input_logger = DataDumper.new "input_log"
puts 'connecting to endpoint server'
return_logger = DataDumper.new "return_log"

while data = client.gets
  socket_to_endpoint = TCPSocket.new 'localhost', 9000
  puts 'from client:', data
  input_logger.log_data data
  socket_to_endpoint.print data
  received = socket_to_endpoint.read
  return_logger.log_data received
  client.write "received: #{data}"
  socket_to_endpoint.close
end

puts 'done'
#trap('EXIT') { [return_logger, input_logger].each(&:end_dump); [socket_to_endpoint, server].each(&:close) }
