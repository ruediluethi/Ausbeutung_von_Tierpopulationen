import json

data = json.load(open("data.json"))

# Helpers
def get_animal_by_id(animal_id):
    return next(filter(lambda a: a["id"] == animal_id, data["animals"]))

def get_cell_by_id(cell_id):
    return next(filter(lambda a: a["id"] == cell_id, data["cells"]))

cell_count = len(data["cells"])