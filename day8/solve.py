#!/usr/bin/env python3

import re
import numpy as np


def parse(cmd):
    return map(int, re.findall(r'\d+', cmd))

def display(height, width, matrix):
    for y in range(height):
        for x in range(width):
            if m[y][x] == 1:
                print('█', end='')
            else:
                print(' ', end='')
        print()


with open('input.txt') as f:
    cmds = f.read().splitlines()

i, j = (6, 50)

m = np.zeros((i, j), dtype=int)

for cmd in cmds:
    if 'rect' in cmd:
        w, h = parse(cmd)
        m[:h, :w] = 1
    elif 'row' in cmd:
        y, s = parse(cmd)
        m[y] = np.roll(m[y], s)
    elif 'col' in cmd:
        x, s = parse(cmd)
        m.T[x] = np.roll(m.T[x], s)

print(m.sum())

display(i, j, m)
