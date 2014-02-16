require 'logger'
require 'socket'
require 'thread'

# 素数かどうかを判定する
def prime?(num)
	log = Logger.new(STDOUT)
	return false if num == 1
	half = num / 2

	start = Time.now
	count = 0

	# 順番に割り切れるか試す
	(2..half).each do |i|
		# １秒ごとにドットを表示
		if count >= 100_000
			now = Time.now
			diff = now - start
			if diff >= 1
				# log.debug diff
				print '.'
				start = now
			end
			count = 0
		end

		# 割り切れたら素数ではない
		if num % i == 0
			log.debug "#{num} / #{i} = #{num/i}"
			return false
		end
		count += 1
	end

	# 全て割り切れなかったら素数
	puts
	log.debug "#{num} is prime number."
	return true
end

def main
	queue = Queue.new

	# workerスレッドを作成。キューに要求が届き次第、素数判定を行う。
	workers = 3.times do |t|
		Thread.fork do
			while req = queue.deq
				puts "worker#{t}: #{prime?(req)}"
			end
		end
	end

	# ソケットを生成し、要求を常に受け付ける。
	TCPServer.open('localhost', 4444) do |sock|
		loop do
			s = sock.accept
			str = s.read
			queue.enq(str.to_i)
		end
	end
end

main
