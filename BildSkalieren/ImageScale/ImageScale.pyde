key_color = 10
vertexes = []
coords = [(2050, 460), (2289, 1252), (2395, 1212), (2350, 399)]

class Vertex:
    def __init__(self, name, coords):
        self.name = name
        self.coords = coords
        self.surface = createGraphics(width, height)

    def build_vertex(self):
        beginShape()
        fill(color(0, 180, 12))
        for i in range(len(self.coords)):
            x = self.coords[i][0] /4
            y = self.coords[i][1] /4
            vertex(x, y)
        endShape(CLOSE)
            
    def outline_points(self):
        with self.surface.beginDraw():
            self.surface.fill(color(0, 255, 0))
            self.surface.circle(x, y, 10)
    


def setup():
    size(1500, 1000)
    global pic, v
    pic = loadImage("DSC05212.JPG")
    v = Vertex('zitat1', coords)
    frameRate(12)
    
    
def draw():
    global pic, key_color, v
    image(pic, 0, 0, width, height)
    v.build_vertex()

    changePixels()
    
def changePixels():
    global key_color
    loadPixels()
    for x in range(width):
        for y in range(height):
            loc = x + y * width
            r = red(pixels[loc])
            g = green(pixels[loc])
            b = blue(pixels[loc])
            
            if r < key_color and g < key_color and b < key_color:
                pixels[loc] = color(255, 0, 0)
    updatePixels()
