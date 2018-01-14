from Code.cellular.model import Base
import matplotlib.pyplot as plt
from numpy import arange
import time
t = time.time()

base = Base("animals.xml")
duration = base.duration
for n in range(int(duration/base.delta)):
    base.tick()

species = "Blauwal"
species2 = "Plankton"
change, amount = base.cells[(0,0)].export()
plt.plot(arange(0,duration, base.delta),amount[species], 'g', arange(0,duration, base.delta),amount[species2], "r", arange(0, duration, base.delta), base.cells[(0,0)]._killed, "b")
print(time.time()-t)

plt.show()
#plt.plot(arange(0, 100, base.delta), base.cells[(0,0)]._killed)
#plt.show()
#print(sorted(list(base.cells[(0, 0)].entities.values())[0], key=lambda x: x.born)[-2])