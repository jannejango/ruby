require 'logger'
require 'socket'

# 乱数を生成して、判定プロセスに送りつける

TCPSocket.open('localhost', 4444) do |sock|
	num = Random.rand(1_000_000..1_000_000_000)
	sock.write(num)
end

