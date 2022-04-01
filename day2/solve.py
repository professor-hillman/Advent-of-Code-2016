#!/usr/bin/env python3


def keypad1():

	xs = [ -1, 0, 1, -1, 0, 1, -1, 0, 1 ]
	ys = [ 1, 1, 1, 0, 0, 0, -1, -1, -1 ]
	cs = '123456789'

	keypad1 = { (x, y): c for x, y, c in zip(xs, ys, cs) }

	return keypad1

def keypad2():

	xs = [ 0, -1, 0, 1, -2, -1, 0, 1, 2, -1, 0, 1, 0 ]
	ys = [ 2, 1, 1, 1, 0, 0, 0, 0, 0, -1, -1, -1, -2 ]
	cs = '123456789ABCD'

	keypad2 = { (x, y): c for x, y, c in zip(xs, ys, cs) }

	return keypad2

def decode(pad, data):

	steps = {'R': (1, 0), 'L': (-1, 0), 'U': (0, 1), 'D': (0, -1)}

	x, y, code = 0, 0, ''

	for row in data:	
		for step in row:
			xx, yy = steps.get(step)
			
			if (x + xx, y + yy) in pad:
				x, y = (x + xx, y + yy)
			else:
				continue
		
		code += pad[(x, y)]

	return code


with open('input.txt') as f:
	data = f.read().splitlines()


print(decode(keypad1(), data))
print(decode(keypad2(), data))

print(data)