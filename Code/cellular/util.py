import random, math
def get_animals_by_species(animals, species):
    return filter(lambda x: x.species == species, animals)


def increase_by_factor(n, fac):
    b = n*fac
    f = math.floor(b)
    if random.random() > b-f:
        return int(f)
    else:
        return int(f+1)

class adult_checker:
    def __init__(self, species, time):
        self.species = species
        self.time = time
    def is_adult(self,entity):
        return True if not self.species.reproduction_age else \
            self.time-entity.born >= self.species.reproduction_age

    def get_adult_count(self, animals):
        n = 0
        for a in animals[::-1]:
            if not self.is_adult(a):
                n += 1
            else:
                break
        return len(animals)-n



