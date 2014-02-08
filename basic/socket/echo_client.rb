# Original src from
# http://docs.ruby-lang.org/ja/2.0.0/class/TCPSocket.html
require "socket"

# ARGV[0]で指定されたポート番号を使用する。
port = if ARGV.size > 0 then ARGV.shift else 4444 end
print port, "\n"

s = TCPSocket.open("localhost", port)

while gets
  s.write($_)
  print(s.gets)
end
s.close
