a = %w[0 0 0 0 0 0 0 0]
b = %w[A A A A A A A A]
c = %w[X X X X X X X X]
d = %w[M M M M M M M M]
e = %w[T T T T T T T T]
master = a,b,c,d,e
SeqLength = 8

# Crossover parents and produce array of 2 children
def crossover(seq1, seq2)
	seq1 = seq1[-8..-1]
	seq2 = seq2[0..7]
	crossString = rand(SeqLength - 1)
	seq1 = seq1 + seq2.slice!(0..crossString)
	seq2 = seq2 + seq1.slice!(0..crossString)
	childrenOut = [seq1, seq2]
	#childrenOut.each {|i| print i.to_s + "\n"}
end


# Iterate through parent combos, 2 children for each 
# combination of 2 parents, producing n(n-1) children
children = []
parentNum = master.length.to_i - 1
master.length.times do |i|
	i.upto(parentNum) do |x| 
		if x != i
# Enable this to print combination #'s
# 			puts "This index: " + i.to_s + " and This index: " + x.to_s + "\n"
			children = children << crossover(master[i], master[x])
		end
	end
end


# Print each pair of children
children.each do |i| 
	i.each do |x|
		print x.to_s + "\n"
	end
end