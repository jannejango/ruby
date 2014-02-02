#encoding: utf-8
class Ruler
	length=5 # メソッド外の変数

	def length=(len)
		length=len # メソッド内の変数
	end

	def length
		# length  # 未定義の変数を評価しようとしてエラーになる。
	end
end

ruler1=Ruler.new
ruler1.length=10
puts ruler1.length #=> nil

ruler2=Ruler.new
ruler2.length=20
puts ruler2.length #=> nil
