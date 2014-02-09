# get array of c comments
def get_comments file
	File.open(file) {|f|
		str=f.read
		str.scan(/(\/\*.*?\*\/)/m)
	}
end

# print c comments
get_comments(ARGV[0]).each_with_index {|comment, index|
	puts 'Comment No.'+index.to_s
	puts comment
	puts
}
