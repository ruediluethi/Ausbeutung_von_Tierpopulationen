from .util import increase_by_factor, get_animals_by_species

class Cell:
    def __init__(self, x, y, K, entities=[]):
        self.x = x
        self.y = y
        self.limit = K
        self.entities = entities
        self._stored = []

    def get_species(self):
        species = {}
        for e in self.entities:
            if e.species not in species:
                species.update({e: 1})
            else:
                species[e] += 1
        return species

    def tick(self, timer):


        for species, count in self.get_species():

