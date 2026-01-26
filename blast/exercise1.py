# Print the longest repeat of values of 100 coin flips

import random

outcomes = random.choices([0, 1], k=100)

c = 1
counts = []
o_prev = outcomes[0]

for o in outcomes[1:]:
    if o == o_prev:
        c += 1
    else:
        counts.append(c)
        c = 1

    o_prev = o

counts.append(c)

print(max(counts))
