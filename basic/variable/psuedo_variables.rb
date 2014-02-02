#encoding: utf-8

# selfは自身を表す。トップレベルではObjectクラスのmainオブジェクト。
print 'self: ', self
puts

class Apple
	def func
		print 'self in instance method: ', self
		puts
	end
	def self.cfunc
		print 'self in class method: ', self
		puts
	end
end

apple=Apple.new
apple.func
Apple.cfunc

# 実行しているファイル名
print '__FILE__: ', __FILE__
puts

# 実行している行番号
print '__LINE__: ', __LINE__
puts

# エンコーディング
print '__ENCODING__: ', __ENCODING__  # ruby 1.8.7だと取得できない？
puts
