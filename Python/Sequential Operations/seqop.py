def seqop(n):
	result = 1
	for i in range(2, n + 1):
		if(i % 4 == 2):
			result += i
		elif(i % 4 == 3):
			result -= i
		elif(i % 4 == 0):
			result *= i
		elif(i % 4 == 1):
			result /= float(i)
	return result

print(seqop(1243247))