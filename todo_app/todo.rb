require 'optparse'
require 'logger'

class Todo
	def initialize
		@logger = Logger.new(STDOUT)
		@subcmd
		@subopt = Hash.new
	end

	def cmdline_parse(argv)
		case argv[0]
		when 'create'
			@subcmd = :create
			cr_parse(argv)
		when 'list'
			@subcmd = :list
			li_parse(argv)
		when 'update'
			@subcmd = :update
			up_parse(argv)
		when 'delete'
			@subcmd = :delete
		when '-v', '--version'
			puts 'version: 0.0.1'
			exit(0)
		when '-h', '--help'
			puts 'This is help'
			exit(0)
		else
			warn 'Usage error.'
			exit(1)
		end
	end

	def cr_parse(argv)
		OptionParser.new do |opt|
			opt.on("-n", "--name"){|v| @subopt[:name] = v }
			opt.on("-c", "--content"){|v| @subopt[:content] = v}
			opt.parse!(argv)
			@logger.debug "argv: #{argv}"
		end
	end

	def li_parse(argv)
		OptionParser.new do |opt|
			opt.on("-s", "--status"){|v| @subopt[:status] = v}
			opt.parse!(argv)
			@logger.debug "argv: #{argv}"
		end
	end

	def up_parse(argv)
		OptionParser.new do |opt|
			opt.on("-n", "--name"){|v| @subopt[:name] = v }
			opt.on("-c", "--content"){|v| @subopt[:content] = v}
			opt.on("-s", "--status"){|v| @subopt[:status] = v}
			opt.parse!(argv)
			@logger.debug "argv: #{argv}"
		end
	end
end

todo = Todo.new
todo.cmdline_parse(ARGV)
