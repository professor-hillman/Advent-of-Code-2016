#!/usr/bin/env python3

import numpy as np
from collections import Counter


with open('input.txt') as f:
    data = [ list(line) for line in f.read().splitlines() ]

M = np.array(data).transpose()

get_most_common = lambda x: Counter(x).most_common()[0][0]
get_less_common = lambda x: Counter(x).most_common()[-1][0]

msg_checksum = ''.join(map(get_most_common, M))
msg_original = ''.join(map(get_less_common, M))

print(msg_checksum)
print(msg_original)
