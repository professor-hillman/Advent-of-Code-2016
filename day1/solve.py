#!/usr/bin/env python3

import re
from collections import deque


def part1(L, N):

	dirs = deque([ 'N', 'E', 'S', 'W' ])

	x, y = 0, 0

	for l, n in zip(L, N):
		if l == 'L':
			dirs.rotate(1)
		else:
			dirs.rotate(-1)

		facing = dirs[0]

		if facing == 'N':
			y -= n
		elif facing == 'S':
			y += n
		elif facing == 'W':
			x -= n
		else:
			x += n

	taxi = abs(x) + abs(y)

	return taxi


def part2(L, N):

	dirs = deque([ 'N', 'E', 'S', 'W' ])

	x, y, spots = 0, 0, set()

	for l, n in zip(L, N):
		
		if l == 'L':
			dirs.rotate(1)
		else:
			dirs.rotate(-1)

		facing = dirs[0]

		ox, oy = x, y

		if facing == 'N':
			y -= n
			for i in range(oy - 1, y - 1, -1):
				if (x, i) in spots:
					return abs(x) + abs(i)
				else:
					spots.add((x, i))
		elif facing == 'S':
			y += n
			for i in range(oy + 1, y + 1, 1):
				if (x, i) in spots:
					return abs(x) + abs(i)
				else:
					spots.add((x, i))
		elif facing == 'W':
			x -= n
			for i in range(ox - 1, x - 1, -1):
				if (i, y) in spots:
					return abs(i) + abs(y)
				else:
					spots.add((i, y))
		else:
			x += n
			for i in range(ox + 1, x + 1, 1):
				if (i, y) in spots:
					return abs(i) + abs(y)
				else:
					spots.add((i, y))


with open('input.txt') as f:
	data = f.read()

L = re.findall(r'[LR]', data)
N = list(map(int, re.findall(r'\d+', data)))

p1 = part1(L, N)
print(p1)

p2 = part2(L, N)
print(p2)