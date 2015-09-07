def get_loc(k):
	if k == '#':
		return (3, 2)
	if k == '0':
		return (3, 1)
	k = int(k)
	return ((k-1)//3, (k - 1) % 3)

def get_dist(k1, k2):
	k1 = get_loc(k1)
	k2 = get_loc(k2)
	return pow((k1[0] - k2[0]) ** 2 + (k1[1] - k2[1]) ** 2, 0.5)

def get_key(c):
	if 'a' <= c <= 'c':
		return ('2', ord(c) - ord('a') + 1)
	if 'd' <= c <= 'f':
		return ('3', ord(c) - ord('d') + 1)
	if 'g' <= c <= 'i':
		return ('4', ord(c) - ord('g') + 1)
	if 'j' <= c <= 'l':
		return ('5', ord(c) - ord('j') + 1)
	if 'm' <= c <= 'o':
		return ('6', ord(c) - ord('m') + 1)
	if 'p' <= c <= 's':
		return ('7', ord(c) - ord('p') + 1)
	if 't' <= c <= 'v':
		return ('8', ord(c) - ord('t') + 1)
	if 'w' <= c <= 'z':
		return ('9', ord(c) - ord('w') + 1)
	elif c == ' ':
		return ('0', 1)
	else:
		print('UNKNOWN CHARACTER')

def get_seq(str):
	out = []
	for c in str:
		k = get_key(c)
		if len(out) > 0 and out[-1] == k[0]:
			out += '#'
		out += (k[0] * k[1])
	return out

def get_best_move(seq, l, r, deep, cdist = 0):
	if deep == 1 or len(seq) == 1:
		dl = cdist + get_dist(l, seq[0])
		dr = cdist + get_dist(r, seq[0])
		if dl < dr:
			return (dl, seq[0], r, deep - 1)
		return (dr, l, seq[0], deep - 1)

	for i in range(deep):
		dl = get_best_move(seq[1:], seq[0], r, deep - 1, cdist + get_dist(l, seq[0]))
		dr = get_best_move(seq[1:], l, seq[0], deep - 1, cdist + get_dist(r, seq[0]))
		if dl[0] < dr[0]:
			return dl
		return dr

def get_time(str):
	depth = 11
	l = 4
	r = 6
	time = 0.0
	seq = get_seq(str)
	i = 0
	while i < len(seq):
		m = get_best_move(seq[i:], l, r, depth)
		l = m[1]
		r = m[2]
		time += m[0]/30 + (depth - m[3]) * .2
		i += (depth - m[3])
	return time

while True:
	try:
		s = input()
		print(len(s))
		print('%.2f' % get_time(s))
	except:
		break
