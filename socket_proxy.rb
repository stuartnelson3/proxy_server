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

#t1 = Thread.new do
#  puts 'connecting to endpoint server'
#  socket_to_endpoint = TCPSocket.new 'localhost', 9000
#  return_logger = DataDumper.new "return_log"
#  while received = socket_to_endpoint.gets
#    return_logger.log_data received
#  end
#end

t2 = Thread.new do
  puts 'starting server on port 8080'
  proxy_server = TCPServer.new 8080
  input_logger = DataDumper.new "input_log"
  client = proxy_server.accept
  while data = client.gets
    puts 'from client:', data
    input_logger.log_data data
    client.write "received: #{data}"
  end
end
t2.join
#[t1, t2].each(&:join)

puts 'done'
#trap('EXIT') { [return_logger, input_logger].each(&:end_dump); [socket_to_endpoint, server].each(&:close) }
