from lazpaint import tools, image, layer, dialog
import math, random

def line(x, y, x2, y2):
    tools.choose(tools.PEN)
    tools.mouse([(x, y), (x2, y2)])
    tools.keys(tools.KEY_RETURN)

MULTIPLIER = dialog.input_value("Zoom", 10)
DEG_TO_RAD = math.pi / 180

def drawTree(x1, y1, angle, depth):
    if (depth > 0):
        x2 = x1 + (math.cos(angle * DEG_TO_RAD) * depth * MULTIPLIER)
        y2 = y1 + (math.sin(angle * DEG_TO_RAD) * depth * MULTIPLIER)
        line(x1, y1, x2, y2)
        drawTree(x2, y2, angle - random.randint(15,50), depth - 1.44)
        drawTree(x2, y2, angle + random.randint(10,25), depth - 0.72)
        drawTree(x2, y2, angle - random.randint(10,25), depth - 3)
        drawTree(x2, y2, angle + random.randint(15,50), depth - 4)

layer.new()
drawTree(image.get_width() / 2, image.get_height(), -91, 9)