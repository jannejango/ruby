# DB作成、テーブル作成、レコード追加、テーブル表示の例
# 主キー制約により、重複レコードを追加しようとするとエラーになる。
require 'sqlite3'

db = SQLite3::Database.new("sample.db")

=begin
sql = <<SQL
drop table players;
SQL
db.execute(sql)
=end

sql = <<SQL
create table if not exists players (
ID integer primary key,
name varchar(10),
team varchar(10)
);
SQL
db.execute(sql)

sql = <<SQL
delete from players;
SQL
db.execute(sql)

sql = <<SQL
insert into players values(1, 'やっと', 'ガンバ');
SQL
db.execute(sql)

sql = <<SQL
insert into players values(2, '俊介', 'マリノス');
SQL
db.execute(sql)

sql = <<SQL
select * from players
;
SQL
p db.execute(sql)

db.close
