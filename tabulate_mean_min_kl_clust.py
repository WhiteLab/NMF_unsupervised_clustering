#!/usr/bin/env python

import sys
from statistics import mean
c_dict = {}

for line in open(sys.argv[1]):
    fn = line.rstrip('\n')
    cur = open(fn)
    next(cur)
    cnum = next(cur)
    c_info = cnum.rstrip('\n').split()
    num_k = int(c_info[1])
    if num_k not in c_dict:
        c_dict[num_k] = []
        sys.stderr.write('Processing files for cluster ' + str(num_k) + '\n')
    next(cur)
    next(cur)
    min_k = next(cur)
    min_info = min_k.rstrip('\n').split()
    c_dict[num_k].append(float(min_info[1]))
    cur.close()

print('Cluster\tmin KL')
for k in sorted(c_dict):
    print(str(k) + '\t' + str(mean(c_dict[k])))
