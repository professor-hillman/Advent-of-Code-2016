#!/usr/bin/env python3

import re


p = re.compile(r'\d+')

with open('input.txt') as f:
	stats = [ list(map(int, p.findall(line))) for line in f.read().splitlines() ]

def is_triangle(sides):
	a, b, c = sides
	if (a + b > c) and (b + c > a) and (a + c > b):
		return True
	return False

triangles = sum(map(is_triangle, stats))

print(triangles)

stats = [ a for a, _, _ in stats ] + [ b for _, b, _ in stats ] + [ c for _, _, c in stats ]
stats = [ stats[i:i+3] for i in range(0, len(stats), 3) ]

triangles = sum(map(is_triangle, stats))

print(triangles)