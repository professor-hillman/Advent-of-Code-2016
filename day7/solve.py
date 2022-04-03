#!/usr/bin/env python3

import re


def parse_ipv7(entry):
    p = re.compile(r'\[(\w+)\]')
    hypernets = p.findall(entry)
    for hypernet in hypernets:
        entry = entry.replace(hypernet, '')
    supernets = entry.split('[]')
    return supernets, hypernets   

def abba(string):
    subs = [ string[i:i+4] for i in range(0, len(string) - 3) ]
    def check(sub):
        if sub[0] == sub[3] and sub[1] == sub[2] and sub[0] != sub[1]:
            return True
        return False
    return any(map(check, subs))

def tls(entry):
    supernets, hypernets = parse_ipv7(entry)
    if any(map(abba, supernets)) and not any(map(abba, hypernets)):
        return True
    return False

def get_babs(string):
    subs = [ string[i:i+3] for i in range(0, len(string) - 2) ]
    def check(sub):
        if sub[0] == sub[2] and sub[0] != sub[1]:
            return True
        return False
    abas = set([ sub for sub in subs if check(sub) ])
    babs = [ (aba[1] + aba[0] + aba[1]) for aba in abas ]
    return babs

def ssl(entry):
    supernets, hypernets = parse_ipv7(entry)
    babs = sum([ get_babs(supernet) for supernet in supernets ], [])
    ssl = any([ bab in hypernet for bab in babs for hypernet in hypernets ])
    return True if ssl else False


with open('input.txt') as f:
    ips = f.read().splitlines()

tls_count = sum(map(tls, ips))
ssl_count = sum(map(ssl, ips))

print(f'Part 1: {tls_count}')
print(f'Part 2: {ssl_count}')
