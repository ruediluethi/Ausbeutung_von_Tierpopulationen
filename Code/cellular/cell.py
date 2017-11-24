class Cell:
    def __init__(self, x, y, K, entities=[]):
        self.x = x
        self.y = y
        self.limit = K
        self.entities = entities

    def tick(self):
