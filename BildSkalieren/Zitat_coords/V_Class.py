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
        # fill vertex with v.col
        with self.surface.beginDraw():
            # self.surface.background(125, 122, 30)
            self.surface.beginShape()
            self.surface.fill(self.v_col)
            for i in range(len(self.coords)):
                x = self.coords[i][0]
                y = self.coords[i][1]
                self.xs.append(x)
                self.ys.append(y)
                vec = PVector(x,y)
                self.vectors.append(vec)
                self.surface.vertex(x, y)
            self.surface.endShape(CLOSE)
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
                    #if a pixel has the color v.col copy its location
                    if c == self.v_col:
                        locs.append(loc)
                        x1 = x - min(self.xs)
                        y1 = y - min(self.ys)
                        small_locs.append(x1 + y1 * self.vert_surface.width)
        # print("small  {}  locs  {}".format(small_locs, locs))
        return locs, small_locs
    
    def calculate_angle(self) :
        self.direction = PVector.sub(self.vectors[1], self.vectors[0])
        # self.vector.normalize()
        ref_vector = PVector(10, 0)
        print("heading:  ", self.direction.heading())
        print("self vec {}  ref vect {}".format(self.direction, ref_vector))
        stroke(255,0,0)
        angle = PVector.angleBetween(self.direction, ref_vector)
        print(angle)
        return angle
