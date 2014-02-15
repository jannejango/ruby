require 'optparse'
require 'logger'
require 'sqlite3'

# ToDoリストを管理するコマンドラインアプリ
# ネタはパーフェクトRuby15章より
# ただし、仕様は正確に沿ってはいない。
class Todo
	def initialize
		@logger = Logger.new(STDOUT)
	end

	# サブコマンドで場合分け
	def cmdline_parse(argv)
		@subcmd
		@subopt = Hash.new
		@id
		case argv[0]
		when 'create'
			@subcmd = :create
			cr_parse(argv)
			if @subopt[:name].nil? || @subopt[:content].nil?
				warn "--name and --content option needed!"
				exit(1)
			end
		when 'list'
			@subcmd = :list
			li_parse(argv)
		when 'update'
			@subcmd = :update
			up_parse(argv)
		when 'delete'
			@subcmd = :delete
			del_parse(argv)
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
		@logger.debug "@subopt: #{@subopt}"
	end

	# サブコマンドcreate時のオプションパース
	def cr_parse(argv)
		OptionParser.new do |opt|
			opt.on("-n NAME", "--name NAME"){|v| @subopt[:name] = v }
			opt.on("-c CONTENT", "--content CONTENT"){|v| @subopt[:content] = v}
			opt.parse!(argv)
			@logger.debug "argv: #{argv}"
		end
	end

	# サブコマンドlist時のオプションパース
	def li_parse(argv)
		OptionParser.new do |opt|
			opt.on("-s STATUS", "--status STATUS"){|v| @subopt[:status] = v}
			opt.parse!(argv)
			@logger.debug "argv: #{argv}"
		end
	end

	# サブコマンドupdate時のオプションパース
	def up_parse(argv)
		OptionParser.new do |opt|
			opt.on("-n NAME", "--name NAME"){|v| @subopt[:name] = v }
			opt.on("-c CONTENT", "--content CONTENT"){|v| @subopt[:content] = v}
			opt.on("-s STATUS", "--status STATUS"){|v| @subopt[:status] = v}
			opt.parse!(argv)
			@logger.debug "argv: #{argv}"
			if argv[1].nil?
				warn "id option needed!"
				exit(1)
			else
				@id = argv[1]
			end
		end
	end

	# サブコマンドdelete時のオプションパース
	def del_parse(argv)
		if argv[1].nil?
			warn "id option needed!"
			exit(1)
		else
			@id = argv[1]
		end
	end

	def main
		# カレントのDBファイルを読み込む。無ければ新規作成。
		@db = SQLite3::Database.new("todo.db")

		# todoテーブルが無ければ新規作成。
		db_init

		case @subcmd
		when :create
			db_create_record
		when :list
			db_list_record
		when :update
			db_update_record
		when :delete
			db_delete_record
		else
			warn "Unexpected error."
			exit(1)
		end

		# 最後にtodoテーブルを表示
		db_show
	end

	def db_init
		sql = <<-SQL
			create table if not exists todo(
				id integer primary key autoincrement,
				name text,
				content text,
				status integer
			);
		SQL
		@db.execute(sql)
	end

	def db_show
		sql = <<-SQL
			select * from todo;
		SQL
		arr = @db.execute(sql)
		print_table(arr)
	end

	# select文の応答をテーブル形式で表示
	def print_table(arr)
		# PRAGMA table_infoコマンドでフィールド（カラム）の情報を取得
		@db.execute('PRAGMA table_info(todo)').each do |row|
			print "#{row[1]}\t"
		end
		puts
		puts "------------------------------"
		arr.each do |row|
			puts row.join("\t")
		end
		puts 
	end

	def db_create_record
		sql = <<-SQL
			insert into todo(name, content, status)
			values('#{@subopt[:name]}', '#{@subopt[:content]}', #{Status::NotYet});
		SQL
		@db.execute(sql)
	end

	def db_list_record
		str = ''
		unless @subopt[:status].nil?
			str = "where status=#{@subopt[:status]}"
		end
		sql = <<-SQL
			select * from todo #{str};
		SQL
		arr = @db.execute(sql)
		print_table(arr)
	end

	def db_update_record
		set_fields = Array.new
		unless @subopt[:name].nil?
			set_fields.push "name='#{@subopt[:name]}'"
		end
		unless @subopt[:content].nil?
			set_fields.push "content='#{@subopt[:content]}'"
		end
		unless @subopt[:status].nil?
			set_fields.push "status='#{@subopt[:status]}'"
		end
		str = set_fields.join(',')
		@logger.debug "set_fields: #{str}"
		sql = <<-SQL
			update todo set #{str} where id=#{@id};
		SQL
		@db.execute(sql)
	end

	def db_delete_record
		sql = <<-SQL
			delete from todo where id=#{@id};
		SQL
		@db.execute(sql)
	end
end

module Status
	NotYet = 0
	Done = 1
	Pending = 2
end

todo = Todo.new
todo.cmdline_parse(ARGV)
todo.main
