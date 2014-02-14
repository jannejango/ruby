require 'net/http'
require 'uri'
require 'logger'

log = Logger.new(STDOUT)

url = URI.parse('http://docs.ruby-lang.org/ja/2.0.0/doc/index.html')
log.debug "url: #{url}, url.class: #{url.class}"
res = Net::HTTP.start(url.host, url.port) {|http|
	# getでは、必ずdocument rootからのパスで指定すること。
	http.get('/ja/2.0.0/doc/index.html')
}
log.debug "res: #{res}, res.class: #{res.class}"

log.debug "encoding: #{res.body.to_s.force_encoding("UTF-8").encoding}"
arr = res.body.to_s.scan(/<li>(.*?)<\/li>/)
arr.each do |li|
	puts li
end
