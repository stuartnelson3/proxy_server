quick example of a simple proxy server in ruby. check out
http://tomayko.com/writings/unicorn-is-unix to see how to implement this
with fork instead of threads. you can also exchange the TCPSocket
arguments with 'localhost' and 4567 if you want to use the app.rb file.
