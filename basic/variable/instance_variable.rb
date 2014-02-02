#encoding: utf-8
class Ruler
	# setter. 
	def length=(len) # イコール記号も関数名の一部。
		@length=len  # インスタンス変数
	end

	# getter. 
	def length
		@length
	end
end

ruler1=Ruler.new
ruler1.length=10
puts ruler1.length

ruler2=Ruler.new
ruler2.length=20
puts ruler2.length
