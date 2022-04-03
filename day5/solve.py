#!/usr/bin/env python3

from hashlib import md5
from itertools import count


doorid = b'ugkcyxxp'

code = ''
for i in count():
    src = doorid + str(i).encode()
    hsh = md5(src).hexdigest()
    if hsh.startswith('00000'):
        code += hsh[5]
    if len(code) == 8:
        break

print(code)

code = ['_'] * 8
for i in count():
    src = doorid + str(i).encode()
    hsh = md5(src).hexdigest()
    pos, val = hsh[5], hsh[6]
    if hsh.startswith('00000') and pos.isdigit():
        pos = int(pos)
        if 0 <= pos <= 7 and code[pos] == '_':
            code[pos] = val
            print(''.join(code), end='\r')
    if '_' not in code:
        break

code = ''.join(code)
print(code)