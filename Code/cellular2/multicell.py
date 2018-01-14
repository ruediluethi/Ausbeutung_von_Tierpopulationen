from Code.cellular2.cell import Cell
from Code.cellular2.constants import TIME_DELTA
from Code.cellular2.data import get_animal_by_id, get_cell_by_id, data


class Multicell:
    def __init__(self, d):
        self.cells = {}
        for cell in d["cells"]:
            self.cells.update()
