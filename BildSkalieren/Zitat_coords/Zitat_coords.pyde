key_color = 10
vertexes = []
coords = [(518, 118), (575, 313), (605, 306), (545, 113)]
t = 0


class Vertex:
    vert_surface = None
    xs, ys = [], [] # cordinates splitted
    vectors = []
    def __init__(self, name, coords, v_col):
        self.name = name
        self.coords = coords
        self.v_col = v_col
        self.surface = createGraphics(width, height)
        self.build_vertex()
        self.angle = self.calculate_angle()
        self.locations, self.vertex_locs = self.vertex_locations()
        

    def build_vertex(self):
       
        beginShape()
        fill(self.v_col)
        for i in range(len(self.coords)):
            x = self.coords[i][0]
            y = self.coords[i][1]
            self.xs.append(x)
            self.ys.append(y)
            vec = PVector(x,y)
            self.vectors.append(vec)
            vertex(x, y)
        endShape(CLOSE)
        vert_width = max(self.xs) - min(self.xs)
        vert_height = max(self.ys) - min(self.ys)
        self.vert_surface = createGraphics(vert_width, vert_height)
    
    def vertex_locations(self):
        locs, small_locs = [], []
        with self.surface.beginDraw():
            self.surface.loadPixels()
            for x in range(self.surface.width):
                for y in range(self.surface.height):
                    loc = x + y*width
                    c = self.surface.pixels[loc]
                    if c == self.v_col:
                        locs.append(loc)
                        x1 = x - min(self.xs)
                        y1 = y - min(self.ys)
                        small_locs.append(x1 + y1 * self.vert_surface.width)
        return locs, small_locs
    
    def calculate_angle(self) :
        self.vector = self.vectors[0]
        ref_vector = PVector(self.vector.x +100,  self.vector.y)
        self.angle = PVector.angleBetween(self.vector, ref_vector)
        line(self.vector.x, self.vector.y, ref_vector.x, ref_vector.y)
        print("angle  {}".format(self.angle))
        pushMatrix()
        fill(220, 125)
        rotate(-self.angle)  # wieso funz das nicht?
        rect(self.vector.x, self.vector.y, 30, 60)
        popMatrix()
        
    
    

def setup():
    size(1500, 1000)
    global pic, v, loc_v, copy_surface, v_color
    pic = loadImage("DSC05212.JPG")
    v_color = color(0, 180, 12)
    v = Vertex('zitat1', coords, v_color)
    copy_surface = createGraphics(v.vert_surface.width, v.vert_surface.height)
    with copy_surface.beginDraw():
        copy_surface.noFill()
    frameRate(12)

    
def draw():
    global t, pic, v, copy_surface
    # image(pic, 0, 0, width, height)
    if keyPressed :
        copyPixels(v)
    # image(v.surface, 0, 0)
    xoff = noise(t)
    yoff = noise(t)
    xoff = map(xoff, 0, 1, 0, mouseX)
    yoff = map(yoff, 0, 1, 9, mouseX)
    
    # image(copy_surface, xoff, yoff)
    t += 0.02

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
