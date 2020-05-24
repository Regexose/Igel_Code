key_color = 10
vertexes = []
coords = [(518, 118), (575, 313), (605, 306), (545, 113)]
global v

class Vertex:
    vert_surface = None
    xs, ys = [], [] # cordinates splitted
    def __init__(self, name, coords, v_col):
        self.name = name
        self.coords = coords
        self.v_col = v_col
        self.surface = createGraphics(width, height)
        self.build_vertex()
        self.locations, self.vertex_locs = self.vertex_locations()

    def build_vertex(self):
        with self.surface.beginDraw():
            self.surface.background(12, 200)
            self.surface.beginShape()
            self.surface.fill(self.v_col)
            for i in range(len(self.coords)):
                x = self.coords[i][0]
                y = self.coords[i][1]
                self.xs.append(x)
                self.ys.append(y)
                self.surface.vertex(x, y)
            self.surface.endShape(CLOSE)
            vert_width = max(self.xs) - min(self.xs)
            vert_height = max(self.ys) - min(self.ys)
            self.vert_surface = createGraphics(vert_width, vert_height)
            with self.vert_surface.beginDraw():
                self.vert_surface.noFill()
    
    def vertex_locations(self):
        locs, small_locs = [], []
        self.surface.loadPixels()
        with self.surface.beginDraw():
            for x in range(self.surface.width):
                for y in range(self.surface.height):
                    loc = x + y*width
                    c = self.surface.pixels[loc]
                    if c == self.v_col:
                        locs.append(x + y*width)
                        x1 = x - min(self.xs)
                        y1 = y - min(self.ys)
                        small_locs.append(x1 + y1 * self.vert_surface.width)
        return locs, small_locs
    
    def copyPixels(self, pic):
        with self.vert_surface.beginDraw():
            self.vert_surface.noFill()
            self.vert_surface.loadPixels()
            loadPixels()
            for index, loc in enumerate(v.locations):
                self.vert_surface.pixels[v.vertex_locs[index]] = pixels[loc]
            self.vert_surface.updatePixels()  

def setup():
    size(1500, 1000, P2D)
    global pic, v, loc_v, copy_surface, v_color
    # pic = loadImage("Ort_DSC05036_plWeyde.jpg")
    pic = loadImage("DSC05212.JPG")
    v_color = color(0, 180, 12)
    v = Vertex('zitat1', coords, v_color)
    frameRate(12)

    
def draw():
    global pic, v
    image(pic, 0, 0, width, height)
    if keyPressed :
        v.copyPixels(pic)
    print("73")
    image(v.vert_surface, mouseX, mouseY)
    print("75")

def copyPixels(v):
    global pic, copy_surface
    with copy_surface.beginDraw():
        copy_surface.loadPixels()
        loadPixels()
        for index, loc in enumerate(v.locations):
            copy_surface.pixels[v.vertex_locs[index]] = pixels[loc]
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
