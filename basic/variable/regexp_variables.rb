#encoding: utf-8

puts '# ex1'
pattern1=/efg/

str1='abcefghijklmn'
puts pattern1===str1 #=> true
puts str1===pattern1 #=> false パターン（正規表現）を左辺に書かないと意味が違ってしまうようだ。

puts pattern1=~str1  #=> 3 パターンが一致する位置
puts str1=~pattern1  #=> 3 '==='演算子とは異なり、左辺、右辺のどちらにパターンを書いても良さそう？

print '$&: ', $&, "\n"  #=> efg    一致文字列
print '$\': ', $', "\n" #=> hijklm 一致文字列より後ろ
print '$\`: ', $`, "\n" #=> abc    一致文字列より前


puts
puts '# ex2'
pattern2=/(\w+)\s(\w+)\s(\w+)\s(\w+)/

str2='Hello how are you?'
puts pattern2===str2
puts pattern2=~str2
print '$1: ', $1, "\n" #=> Hello 最初の括弧に一致した文字列
print '$2: ', $2, "\n"
print '$3: ', $3, "\n"
print '$4: ', $4, "\n"
