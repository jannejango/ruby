# Original src from
# http://docs.ruby-lang.org/ja/2.0.0/class/TCPServer.html
require "socket"
require "logger"

log = Logger.new(STDOUT)

# Socket作成
# gs = TCPServer.open(0) # 0はIPアドレスの整数値表現（0.0.0.0の意）
gs = TCPServer.open("127.0.0.1", 9090) # 192.168.xx.yy などはbindのエラーになってしまう。
 log.debug "gs: #{gs}, gs.class: #{gs.class}"
socks = [gs]
 log.debug "socks: #{socks}, socks.class: #{socks.class}"
addr = gs.addr
 log.debug "addr: #{addr}, addr.class: #{addr.class}"
addr.shift
 log.debug "addr: #{addr} <= after shift."
printf("server is on %s\n", addr.join(":"))

while true
	puts "waiting..."
	# select: 与えられた入力/出力/例外待ちの IO オブジェクトの中から
	#  準備ができたものを それぞれ配列にして、配列の配列として返します。 
	#  タイムアウトした時には nil を返します。
	#
	# selectでクライアントからの処理を待ち受ける。
	# nsockには今回処理するべきソケットオブジェクトが入る、多分。
	nsock = select(socks)
	 log.debug "nsock: #{nsock}, nsock.class: #{nsock.class}"
	 nsock[0].each_with_index do |s_nsock, index| log.debug "nsock[0][#{index}]: #{s_nsock}" end
	next if nsock == nil
	for s in nsock[0]
		# 新しいクライアントからの接続だった場合、acceptしてsocksに加える。
		if s == gs
			s_acc = s.accept
			 log.debug "s_acc: #{s_acc}, s_acc.class: #{s_acc.class}"
			socks.push(s_acc)
			print(s, " is accepted\n")
			 socks.each_with_index do |s_socks, index| log.debug "socks[#{index}]: #{s_socks}" end
		# 接続済みのクライアントからの処理要求だった場合、エコーする。
		else
			if s.eof?
				# EOFの場合はソケットを閉じる。
				print(s, " is gone\n")
				s.close
				socks.delete(s)
			else
				# エコー。ソケットから文字列を取得し、そのまま書き込む。
				str = s.gets
				s.write(str)
			end
		end
	end
end
