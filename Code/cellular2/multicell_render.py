from PIL import Image, ImageDraw
import json

base_img = Image.new("RGBA", (720, 480), (255, 255, 255))

#base_draw = ImageDraw.Draw(base_img)

with open("json_export.json", "r") as f:
    data = json.loads(f.read())
m = max(max(data[0]["0"]), max(data[0]["1"]), max(data[1]["0"]), max(data[1]["1"]))
for n in range(len(data[0]["0"])):
    img = base_img.copy()
    draw = ImageDraw.Draw(img)
    c0 = round(data[0]["0"][n] / m * 255)
    c1 = round(data[0]["1"][n] / m * 255)
    c2 = round(data[1]["0"][n] / m * 255)
    c3 = round(data[1]["1"][n] / m * 255)
    draw.rectangle([100, 100, 360, 380], fill=(c0, 0, c1), outline="black")
    draw.rectangle([360, 100, 620, 380], fill=(c2, 0, c3), outline="black")
    img.save(f"render/{n}.png")
