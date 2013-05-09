require 'socket'

class DataDumper
  def initialize name
    @name = name
    @file = File.open "#{@name << '_' << Time.now.to_s.split[1].gsub(':','_')}.txt", "a"
  end

  def log_data data
    # @file.write "\n#{@name.upcase}:\n"
    @file.write "#{data}\n"
  end

  def end_dump
    @file.write "\n\n ### END OF DUMP FROM #@name ### \n\n"
    @file.close
    puts "#@name closed"
  end
end

proxy_server = TCPServer.new 8080
loop do
  Thread.new(proxy_server.accept) do |client|
    puts 'starting server on port 8080'

    input_logger = DataDumper.new "input_log"
    puts 'connecting to endpoint server'
    return_logger = DataDumper.new "return_log"
    request = ""
    request_logger = DataDumper.new "request_log"
    while data = client.readline
      puts 'from client:', data
      input_logger.log_data data
      request << data
      if data.strip.empty?
        request_logger.log_data request
        socket_to_endpoint = TCPSocket.new 'localhost', 4567
        socket_to_endpoint.print request
        break
      end
      # received = socket_to_endpoint.read
      # return_logger.log_data received
      # socket_to_endpoint.close
    end

    # buff = ""
    # loop do
      response = socket_to_endpoint.read #(4048, buff)
      client.write response #(buff)
      return_logger.log_data response
      # break if buff.size < 4048
    # end

    [return_logger, input_logger, request_logger].each(&:end_dump)
    socket_to_endpoint.close
    puts 'finished request'
  end
end

trap('EXIT') { proxy_server.close; puts 'closed proxy server' }
