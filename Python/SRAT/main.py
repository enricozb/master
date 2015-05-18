from question import question
questions = list()
def c(self, q, qdict):
	for i in range(1, 21):
		qi = qdict[i]
		if qi.answer == 'b':
			return ord(q.answer) - 96 == i
questions.append(question(question, c, 'a'))