# Usage: ruby ancestors.rb <ClassName> [-m|-mv|-vm]
# 指定したオブジェクト（クラス・モジュール）の祖先を辿り、情報を表示するコマンド

require 'optparse'

# 引数m, vが指定されたかどうかを保持する変数
m = false
v = false

# optparseで引数を解析。m, vをセット。
OptionParser.new do |opt|
	opt.on('-m'){ m = true }  # 変数やメソッドを表示するオプション
	opt.on('-v'){ v = true }  # 全ての情報を省略せずに表示するオプション（例：methodsを全部表示する）
	opt.parse!(ARGV)     # parse!メソッドにより、'-'付きのオプションはARGVから取り除かれる。
end

if ARGV.length < 1
	warn 'Usage: ruby ancestors.rb <ClassName> [-m|-mv|-vm]'
	exit(1)
end

# eval中に予約語があるとSyntaxErrorになるので例外処理。
begin
	obj = eval("#{ARGV[0]}") # evalにより、引数で指定されたオブジェクトのオブジェクトを得る
	stack = obj.ancestors
rescue StandardError, SyntaxError => e
	warn 'Not a ClassName'
	# warn e
	exit(1)
end
p stack

# オブジェクト（クラス・モジュール）の情報を表示
def print_object_info(obj, m=false, v=false)
	# 基本的な情報を表示
	puts "object: #{obj}"
	puts " class: #{obj.class}"
	puts " superclass: #{obj.superclass}" if obj.class == Class
	puts object_info(obj, 'included_modules', v)
	if m
		# 実行するオブジェクトのメソッド一覧
		object_methods = ['constants', 'class_variables', 'instance_variables',
					'methods(false)', # 'singleton_methods(false)',          # methods =~ singleton_methods
					# 'public_methods(false)', 'protected_methods(false)',   # methods = public + protected
					'private_methods(false)',                                # falseは継承分は含めないの意
					'instance_methods(false)',
					# 'public_instance_methods(false)', 'protected_instance_methods(false)', 
					'private_instance_methods(false)'
		]
		# メソッドを実行して表示
		object_methods.each do |method|
			puts object_info(obj, method, v)
		end
	end
	puts
end

# 配列を返すオブジェクトのメソッドを実行し、表示形式に変換して返す。
def object_info(obj, method, v)
	# メソッド実行
	arr = eval("#{obj}.#{method}")
	if v
		str = arr.to_s
	else
		str = arr[0..4].to_s
		str += '...' if arr.length > 5
	end
	return " #{method}[#{arr.length}]: #{str}"
end

# メイン関数コール
stack.reverse_each do |obj|
	print_object_info(obj, m, v)
end
