class Entity:
    def __init__(self, x:int, y:int, species:str, born:int=0):
        self.x = x
        self.y = y
        self.species = species
        self.born = born
    def __str__(self):
        return f"Entity Species {self.species}, born {self.born}, Position {self.x} {self.y}"