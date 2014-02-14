# FixnumとBignumの大雑把な境界を探す
30.times do |m|
	n = 10**m
	printf("n=%d, m=%2d, %s\n", n, m, n.class)
	break if n.class == Bignum
end

# 二分探索で境界を求める
def branch2(low, high)
	printf("low=%d, high=%d\n", low, high)
	return low, high if high - low <= 1
	mid = (low + high) / 2
	if mid.class == Bignum
		branch2(low, mid)
	else
		branch2(mid, high)
	end
end

low = 10**18
high = 10**19
low, high = branch2(low, high)
puts

# 結果は
# Fixnumの最大値：4611686018427387903 (0x3fffffffffffffff)
# Bignumの最小値：4611686018427387904 (0x4000000000000000)
# となった。環境依存のようだが、今回は62ビットまでがFixnumだった。
printf(" low=%d[%s],  low(16)=0x%s\n", low, low.class, low.to_s(16))
printf("high=%d[%s], high(16)=0x%s\n", high, high.class, high.to_s(16))
