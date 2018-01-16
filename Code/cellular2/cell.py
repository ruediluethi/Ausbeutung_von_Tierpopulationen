import random
from typing import List


from Code.cellular2.data import get_animal_by_id, get_cell_by_id
from Code.cellular2.helpers import frange
from Code.cellular2.constants import TIME_DELTA


class Cell:
    def __init__(self, cell):
        self.cell = cell
        self.x = cell["X"]
        self.y = cell["Y"]
        self.meeting = cell["meeting"]
        self.limit = cell["limit"]
        self.animals = {}
        for animal in cell["start_population"]:
            a = get_animal_by_id(animal["id"])
            self.animals.update({animal["id"]: []})
            for n in frange(0, a["maximum_age"], steps=animal["amount"]):
                self.animals[animal["id"]].append(-n)

        self.t = 0
        self._export = {}
        self.verhungert = {}
        self.alter = {}
        for animal in cell["start_population"]:
            self._export.update({animal["id"]: [animal["amount"]]})
            self.verhungert.update({animal["id"]: 0})
            self.alter.update({animal["id"]: 0})


    def born_new_animals(self, animal_id, n):
        a = [self.t] * n
        self.animals[animal_id] = a + self.animals[animal_id]


    @property
    def count_all(self) -> int:
        n = 0
        for animal in self.animals:
            n += len(self.animals[animal])
        return n

    def count(self, animal_id: int):
        return len(self.animals[animal_id])

    def count_adult(self, animal_id: int) -> int:
        animal = get_animal_by_id(animal_id)
        return len(list(filter(lambda x: x - self.t < animal["reproduction_age"], self.animals[animal_id])))

    def kill_animals(self, animal_id, n):
        a: list = self.animals[animal_id]
        i = 0
        while i < n:
            a.pop(random.randint(0, len(a) - 1))
            i += 1


    def move_animals_out(self, animal_id, n):
        r = []
        a: list = self.animals[animal_id]
        i = 0
        while i < n:
            r.append(a.pop(random.randint(0, len(a) - 1)))
            i += 1
        return r

    def add_animals(self, animal_id, animals: List['int']):
        a = self.animals[animal_id]
        a.extend(animals)
        self.animals[animal_id] = sorted(a, reverse=True)

    def kill_old(self, animal_id: int):
        a = self.animals[animal_id]
        animal = get_animal_by_id(animal_id)
        i = len(a)
        while i > 1 and a[i-1] < self.t - animal["maximum_age"]:
            i -= 1
        self.alter[animal_id] += len(a) - i
        del a[i:]

    def tick(self):
        self.t += TIME_DELTA
        for animal in self.animals:
            species = get_animal_by_id(animal)
            self.kill_old(animal)
            adult = self.count_adult(animal)
            total = self.count(animal)
            if "food" in species:
                food_id: int = species["food"]["id"]
                food_lw: float = species["food"]["l_w"]
                food_lv: float = species["food"]["l_v"]
                base_need: float = species["food"]["base_need"]
                food_count = self.count(food_id)
                killed = round(total * food_count * self.meeting * TIME_DELTA * food_lv)
                self.verhungert[animal] += killed
                self.kill_animals(food_id, killed)
                change = round(-species["reproduction"] * (1 - self.count_all/self.limit)* adult * TIME_DELTA + total * (food_count * self.meeting * food_lw - base_need) * TIME_DELTA)  # food_count / (self.limit - total) * food_amount
                #print("Reproduktion: " + str(change))
            else:
                change = round(
                    species["reproduction"] * (1 - self.count_all / self.limit) * adult * TIME_DELTA)

            #change = round(reproduction * (1 - self.count_all / self.limit) * adult * TIME_DELTA)
            #change = 0
            if change > 0:
                self.born_new_animals(animal, change)
            elif change < 0:
                self.kill_animals(animal, -change)

            self._export[animal].append(self.count(animal))

    def export(self):
        return self._export


if __name__ == '__main__':
    c = Cell(get_cell_by_id(0))
    print(c.count_all)
    for o in range(10000):
        c.tick()
    print(c.count(0))
    print(c.alter)
    print(c.verhungert)
    from matplotlib import pyplot

    d = c.export()
    pyplot.plot(d[0])
    pyplot.show()
    pyplot.plot(d[1])
    pyplot.show()

    with open("export.csv", 'w') as myfile:
        d0 = d[0]
        d1 = d[1]
        for n in range(len(d0)):
            myfile.write(f"{d0[n]}, {d1[n]};\n")
        myfile.close()



