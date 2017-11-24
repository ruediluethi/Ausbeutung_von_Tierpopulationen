from xml.etree import ElementTree


class _Animal:
    def __init__(self, xml_objext: ElementTree.Element):
        self.name = xml_objext.get("name")
        maximum_age = xml_objext.find("maximum_age")
        self.maximum_age = int(maximum_age.get("age")) if maximum_age else 0
        reproduction = xml_objext.find("reproduction")
        self.reproduction = float(reproduction.get("r")) if reproduction else 0

class _Cell:
    def __init__(self, xml_object: ElementTree.Element):
        self.x = int(xml_object.get("x"))
        self.y = int(xml_object.get("y"))

        self.inhabitants = {}
        for animal in xml_object.findall("inhabitant"):
            self.inhabitants.update({animal.get("name"): int(animal.get("amount"))})

class Base:
    def __init__(self, xml_file: str):
        self._xml = ElementTree.parse(xml_file)
        self._root = self._xml.getroot()

