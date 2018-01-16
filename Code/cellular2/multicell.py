from Code.cellular2.cell import Cell
from Code.cellular2.constants import TIME_DELTA, cell_movement
from Code.cellular2.data import get_animal_by_id, get_cell_by_id, data
from typing import List
import json


class Multicell:
    def __init__(self, d):
        self.t = 1
        self.cells: List['Cell'] = []
        for cell in d["cells"]:
            self.cells.append(Cell(cell))


    def tick(self):
        self.t += 1
        for animal in data["animals"]:
            animal_id = animal["id"]
            cell0 = self.cells[0]
            cell1 = self.cells[1]
            count_cell_0 = cell0.count(animal_id)
            count_cell_1 = cell1.count(animal_id)
            movement = round((count_cell_1 - count_cell_0)*cell_movement*TIME_DELTA)
            if movement > 0:
                a = cell1.move_animals_out(animal_id, movement)
                cell0.add_animals(animal_id, a)

            elif movement < 0:
                a = cell0.move_animals_out(animal_id, movement)
                cell1.add_animals(animal_id, a)
        for cell in self.cells:
            cell.tick()

    def export(self):
        return [cell.export() for cell in self.cells]

if __name__ == '__main__':
    m = Multicell(data)
    for u in range(3000):
        m.tick()
    e = m.export()
    with open("multi_export.csv", "w") as f:
        for n in range(m.t):
            f.write(f"{e[0][0][n]}, {e[0][1][n]}, {e[1][0][n]}, {e[1][1][n]};\n")

        f.close()
    with open("json_export.json", "w") as f:
        f.write(json.dumps(e))
        f.close()

    from matplotlib import pyplot
    pyplot.plot(e[0][0])
    pyplot.show()
    pyplot.plot(e[0][1])
    pyplot.show()
    pyplot.plot(e[1][0])
    pyplot.show()
    pyplot.plot(e[1][1])
    pyplot.show()
    #print(m.export())


