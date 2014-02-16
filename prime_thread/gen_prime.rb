require 'logger'
require 'socket'

def rand_num
	return Random.rand(1_000_000..1_000_000_000)
end

def gen_rand_nums
	log = Logger.new(STDOUT)

	str = '['
	str += rand_num.to_s
	9.times do
		str += ',' + rand_num.to_s
	end
	str += ']'
	log.debug "str: #{str}"
	return str
end

# 乱数を生成して、判定プロセスに送りつける
loop do
	TCPSocket.open('localhost', 4444) do |sock|
		sock.write(gen_rand_nums)
		sleep 3
	end
end

