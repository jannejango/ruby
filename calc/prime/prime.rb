require 'logger'

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

# 乱数を生成して、素数か判定する
def q
	num = Random.rand(1_000_000..1_000_000_000)
	return prime?(num)
end

100.times do
	puts q
end
