# Author:: jannejango
# Version:: 0.0.1
# License:: Ruby License
#
# ===get comment array from c source
def get_comments file
	File.open(file) {|f|
		str=f.read
		str.scan(/(\/\*.*?\*\/)/m)
	}
end

# print comments
get_comments(ARGV[0]).each_with_index {|comment, index|
	puts 'Comment No.'+index.to_s
	puts comment
	puts
}
