#!/usr/bin/env python3

import re
import string
import numpy as np


def decompress_min(data, result=''):

    while ( m := p.search(data) ):

        match = m.group(0)
        data = data.replace(match, '', 1)
        count, repeat = map(int, d.findall(match))
        chars, data = data[:count], data[count:]
        result += chars * repeat

    return len(result)

def decompress_max(data, ptr=0):

    arr = np.ones(len(data), dtype=np.uint32)

    while p.search(data, ptr):

        match = p.search(data, ptr).group(0)
        _, ptr = p.search(data, ptr).span()
        count, repeat = map(int, re.findall(r'\d+', match))
        arr[ptr:ptr + count] *= repeat

    length = 0
    for i in range(len(data)):
        if data[i] in string.ascii_uppercase:
            length += arr[i]

    return length


with open('input.txt') as f:
    data = f.read()

d = re.compile(r'\d+')
p = re.compile(r'\(\d+x\d+\)')

print(f'Part 1: {decompress_min(data)}')
print(f'Part 2: {decompress_max(data)}')
