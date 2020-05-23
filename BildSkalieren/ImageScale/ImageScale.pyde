key_color = 10
vertexes = []
coords = [(518, 118), (575, 313), (605, 306), (545, 113)]
global v

class Vertex:
    def __init__(self, name, coords, v_col):
        self.name = name
        self.coords = coords
        self.v_col = v_col
        self.surface = createGraphics(width, height)
        self.build_vertex()
        self.locations = self.vertex_locations()

        

    def build_vertex(self):
        with self.surface.beginDraw():
            self.surface.background(12, 200)
            self.surface.beginShape()
            self.surface.fill(self.v_col)
            for i in range(len(self.coords)):
                x = self.coords[i][0]
                y = self.coords[i][1]
                self.surface.vertex(x, y)
            self.surface.endShape(CLOSE)
    
    def vertex_locations(self):
        locs = []
        self.surface.loadPixels()
        with self.surface.beginDraw():
            for x in range(self.surface.width):
                for y in range(self.surface.height):
                    loc = x + y*width
                    c = self.surface.pixels[loc]
                    # r = c >> 16 & 0xFF
                    # g = c >> 8 & 0xFF
                    # b = c & 0xFF 
                    if c == self.v_col:
                        locs.append(x + y*width)
        return locs

def setup():
    size(1500, 1000, P2D)
    global pic, v, loc_v, copy_surface, v_color
    pic = loadImage("DSC05212.JPG")
    v_color = color(0, 180, 12)
    v = Vertex('zitat1', coords, v_color)
    # loc_v = [(coords[i][0] + coords[i][1] * width) for i in range(len(coords))]
    copy_surface = createGraphics(width, height, P2D)
    with copy_surface.beginDraw():
        copy_surface.background(color(12, 100, 200, 100))
    
    frameRate(12)

    
def draw():
    global pic, v, copy_surface
    image(pic, 0, 0, width, height)
    if keyPressed :
        copyPixels(v)
    # image(v.surface, 0, 0)
    image(copy_surface, mouseX, mouseY)

def copyPixels(v):
    global pic, copy_surface
    copy_surface.loadPixels()
    loadPixels()
    print("invertex: ",  len(v.locations))
    for loc in v.locations:
        with copy_surface.beginDraw():
             copy_surface.pixels[loc] = pixels[loc]
    copy_surface.updatePixels()  

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
