require 'socket'

class DataDumper
  def initialize name
    @name = name
    @file = File.open "#{file_name}.txt", "a"
  end

  def file_name
    "#{@name << '_' << Time.now.to_s.split[1].gsub(':','_')}"
  end

  def log_data data
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
    puts 'connection made'

    input_logger = DataDumper.new "input_log"
    return_logger = DataDumper.new "return_log"
    request_logger = DataDumper.new "request_log"
    request = ""
    while data = client.readline
      puts 'from client:', data
      input_logger.log_data data
      request << data
      if data.strip.empty?
        request_logger.log_data request
        socket_to_endpoint = TCPSocket.new 'www.google.com', 80
        socket_to_endpoint.print request
        break
      end
    end

    response = socket_to_endpoint.readpartial 1024 * 64
    client.write response
    return_logger.log_data response

    [return_logger, input_logger, request_logger].each(&:end_dump)
    socket_to_endpoint.close
    puts 'finished request'
  end
end

trap('EXIT') { proxy_server.close; puts 'closed proxy server' }
