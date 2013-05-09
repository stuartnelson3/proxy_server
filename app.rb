require 'sinatra'

get '/' do
  "#{Time.now}"
end
