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

		# 割り切れたら素数ではない
		if num % i == 0
			# log.debug "#{num} / #{i} = #{num/i}"
			return false
		end
		count += 1
	end

	# 全て割り切れなかったら素数
	# puts
	log.debug "#{num} is prime number."
	return true
end

def main
	queue = Queue.new
	log = Logger.new(STDOUT)
	count = 0
	total_time = 0.0
	ave_time = 0.0

	# workerスレッドを作成。キューに要求が届き次第、素数判定を行う。
	workers = 10.times do |t|
		Thread.fork do
			while req = queue.deq
				start = Time.now
				res = prime?(req)
				finish = Time.now
				# puts "worker#{t}: #{res}"

				count += 1
				total_time += finish - start
				ave_time = total_time / count
				# puts "worker#{t}: count: #{count}"
				# puts "average time: #{ave_time}"
			end
		end
	end

	# ソケットを生成し、要求を常に受け付ける。
	TCPServer.open('localhost', 4444) do |sock|
		loop do
			s = sock.accept
			str = s.read
			arr = eval("#{str}")
			arr.each do |num|
				queue.enq(num)
			end
			log.debug "current queue size: #{queue.size}"
			log.debug "count: #{count}"
			log.debug "average processing time: #{ave_time}"
		end
	end
end

main
