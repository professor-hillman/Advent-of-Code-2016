#!/usr/bin/env python3

import re
from collections import Counter


def parse(line):
    name = line.rsplit('-', 1)[0].replace('-', '')
    id = int(re.search(r'\d+', line).group(0))
    checksum = re.search(r'\[(\w+)\]', line).group(1)
    return name, id, checksum

def check(name):
    ctr = Counter(name).most_common()
    srt = sorted(ctr, key=lambda x: (-x[1], x[0]))
    msg = ''.join(map(lambda x: x[0], srt))[:5]
    return msg

def decrypt(cipher, shift):
    ltrs = [ chr(((ord(letter) - 97 + shift) % 26) + 97) for letter in cipher ]
    msg = ''.join(ltrs)
    return msg


with open('day4/input.txt') as f:
    lines = f.read().splitlines()


idsum = sum([ id for name, id, cksum in map(parse, lines) if check(name) == cksum ])

print(idsum)

for line in lines:
    name, id, _ = parse(line)
    msg = decrypt(name, id)
    if 'northpole' in msg:
        sector = id

print(sector)