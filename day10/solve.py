#!/usr/bin/env python3

import re
from math import prod


with open('day10\input.txt') as f:
    data = f.read()

bots = { bot: [] for bot in set(re.findall(r'bot (\d+)', data)) }
outs = { out: [] for out in set(re.findall(r'output (\d+)', data)) }

data = data.splitlines()

d = re.compile(r'\d+')

while True:
    for line in data:
        if 'val' in line:
            val, bot = d.findall(line)
            bots[bot].append(int(val))
            data.remove(line)
        else:
            bot = line.split()[1]
            
            if len(bots[bot]) == 2:
                low, high = sorted(bots[bot])
                
                if low == 17 and high == 61:
                    p1 = bot
                
                low_target, high_target = line.split()[5:7], line.split()[-2:]
                
                if 'bot' in low_target:
                    bots[low_target[1]].append(low)
                else:
                    outs[low_target[1]].append(low)
                
                if 'bot' in high_target:
                    bots[high_target[1]].append(high)
                else:
                    outs[high_target[1]].append(high)
                
                bots[bot] = []
                data.remove(line)

    if (a := outs['0']) and (b := outs['1']) and (c := outs['2']):
        p2 = prod(a + b + c)
        break

print(f'Part 1: {p1}')
print(f'Part 2: {p2}')
