from Code.cellular.model import Base
import matplotlib.pyplot as plt

base = Base("animals.xml")
for n in range(int(100/base.delta)):
    base.tick()

species = "Blauwal"
change, amount = base.cells[(0,0)].export()
plt.plot(range(len(change[species])),change[species], 'g', range(len(amount[species])),amount[species], "r")
plt.show()
#print(sorted(list(base.cells[(0, 0)].entities.values())[0], key=lambda x: x.born)[-2])