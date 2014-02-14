require 'optparse'
OptionParser.new do |opt|
	# optparse -vm など、複数同時指定も可能。
	# onでオプション指定時の動作を登録。
	opt.on('-v'){ p 'verbose' }
	opt.on('-m'){ p 'method' }

	puts 'Before parse'

	# parse実行時に上記で登録した動作が実行される。
	opt.parse!(ARGV)
end
