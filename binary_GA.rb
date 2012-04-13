print "How long would you like the master string to be ?: "
$sequenceLength = gets.chomp.to_i 		# Ask user for master string size
$sequenceMaster = [1] * $sequenceLength
$generations = []
print "What size would you like the gene pool to be ?: "
poolSize = gets.chomp.to_i				# Ask user for initial pool size
print "How many sequences would you like to select for breeding?: "
$parentSizeGet = gets.chomp.to_i		# Ask user for # of sequences to breed
$parentSize = $parentSizeGet - 1
$sequencePool = Array.new(poolSize)
$LastGenParents = []
$genNumber = -1		# Count out generations starting with 0
print "\nMaster Sequence:\n";print $sequenceMaster;print "\n" * 3

# Generate n random binary sequences
$sequencePool.each_index do |newSequence| 
	$sequencePool[newSequence] = Array.new($sequenceLength) { |e| e = rand(2) }
end


# Call method compare(), then pack sequences and scores into new array genSwapPool
def evaluate(pool, genNum)

	# Define submethod to compare arrays item by item and tally score
	# as a percentage, ouput score and percentage
	def compare(seq1, seq2)
		score = 0
		percentScore = 0.0
		compareCount = -1
		seq1.each_index do |x|
			if seq1[x] == seq2[x]
				score += 1
			end
		end
		if score >= 1 then				# Convert score to percentage
			score = seq1.length.to_f / score.to_f
			return percentScore =  100.0 / score
		else
			return percentScore = 0.0
		end
	end
	
	genSwapPool = []
	relativeFitness = []
	pool.each_index do |seqnum|
		relativeFitness[seqnum] = compare($sequenceMaster, pool[seqnum])
		genSwapPool[seqnum] = relativeFitness[seqnum], pool[seqnum]
	end
	
	# Sort by scores then display sequences and scores with parents *'s
	puts "Generation (" + genNum.to_s + ") Sequences: "
	genSwapPool = genSwapPool.sort.reverse
	genSwapPool.each_with_index do |x, i| 
		sequenceDisplayNum = i + 1
		if i <= 8		# Format Reference Numbers correctly
			if i <= $parentSize
					print " " + sequenceDisplayNum.to_s + ".     * " + x[1].to_s + \
					" " +  x[0].to_s + " %\n"
					$LastGenParents[i] = x[1]		# Dump sequences into array for crossover
			else
					print " " + sequenceDisplayNum.to_s + ".       " + x[1].to_s + \
					" " +  x[0].to_s + " %\n"
			end
		else
			if i <= $parentSize
					print sequenceDisplayNum.to_s + ".     * " + x[1].to_s + " " + \
					x[0].to_s + " %\n"
					$LastGenParents[i] = x[1]		# Dump sequences into array for crossover
			else
					print sequenceDisplayNum.to_s + ".       " + x[1].to_s + " " + \
					x[0].to_s + " %\n"
			end
		end
	end
	genSwapPool
end


# Define iterative method for crossover of parents, 2 children for each 
# combination of 2 parents, producing n(n-1) children
def breedNextGen

	# Define nested method for crossing over pairs, producing 2 children
	def crossover(seq1, seq2)
		seqCeiling = $sequenceLength - 1
		seq1 = seq1[(-$sequenceLength)..-1]
		seq2 = seq2[0..seqCeiling]
		crossString = rand($sequenceLength - 1)
		seq1 = seq1 + seq2.slice!(0..crossString)
		seq2 = seq2 + seq1.slice!(0..crossString)
		childrenOut = [seq1, seq2]
		#childrenOut.each { |x| print x.to_s + "\n"}
end
	
newGenSwapPool = []
	parentNum = $LastGenParents.length.to_i - 1
	$LastGenParents.length.times do |i|
		i.upto(parentNum) do |x| 
			if x != i
				newGenSwapPool = newGenSwapPool << \
				crossover($LastGenParents[i], $LastGenParents[x])
#				print i.to_s + ", " + x.to_s + "\n"
			end
		end
	end
newGenSwapPool
end

def generateNewGeneration(query)
	if query == 1
		queryGeneration = "\n"
	else
		queryGeneration = gets
	end
	if queryGeneration == "\n"
		$genNumber += 1
		evaluate($sequencePool, $genNumber)
		$sequencePool = []		# Empty sequencePool every generation
		print "\n" * 3
		breedNextGen().each_index do |i| 
			breedNextGen[i].each do |xx|
				$sequencePool =  $sequencePool + [xx]
			end
		end
		print "[Enter] to proceed to the next generation, or [q] to quit: "
		generateNewGeneration(0)
	elsif queryGeneration.chomp == "q"
		print "Exiting...  \n"
		exit
	else queryGeneration != "q"
		generateNewGeneration(0)
	end
end

generateNewGeneration(1)

