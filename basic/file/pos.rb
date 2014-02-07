# Fileインスタンスのposメソッドは、ファイル中の現在位置（先頭からの文字数）を返す。
# 改行文字も一文字。
File.open(ARGV[0]) do |f|
	puts 'first pos:'+f.pos.to_s
	puts
	f.each_line.with_index do |line, index|
		if index==5 then break end
		puts line
		puts 'size of this line:'+line.length.to_s
		puts 'pos:'+f.pos.to_s
		puts
	end
end

