class question:
	def __init__(self, qdict, condition, answer):
		self.qdict = qdict
		self.condition = condition
		self.answer = answer

	def check(self):
		return self.condition(self, self.qdict)

	def next(self):
		self.answer = chr(ord(self.answer) + 1)
		if self.answer == 'f':
			self.answer = 'a'