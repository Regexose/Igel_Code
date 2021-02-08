class Vertex:
    vert_surface = None
    xs, ys = [], [] # cordinates splitted
    vectors = []
    def __init__(self, name, w, h, coords, v_col):
        self.name = name
        self.h = h
        self.w = w
        self.coords = coords
        self.v_col = v_col
        self.surface = createGraphics(w, h)
        self.build_vertex()
        self.angle = self.calculate_angle()
        self.locations, self.vertex_locs = self.vertex_locations()
        print(len(self.locations))

    def build_vertex(self):
        # make vert_surface and draw colored vertex on it
        for i in range(len(self.coords)):
                x = self.coords[i][0]
                y = self.coords[i][1]
                self.xs.append(x)
                self.ys.append(y)
                vec = PVector(x,y)
                self.vectors.append(vec)
        vert_width = max(self.xs) - min(self.xs)
        vert_height = max(self.ys) - min(self.ys)
        self.vert_surface = createGraphics(vert_width, vert_height)
        with self.vert_surface.beginDraw():
            self.vert_surface.fill(self.v_col)
            self.vert_surface.beginShape()
            for x, y  in zip(self.xs, self.ys):
                x -= min(self.xs)
                y -= min(self.ys)
                if x > 0 or y > 0:
                    print(" x {}   y {}".format(x, y))
                self.vert_surface.vertex(x, y)
            self.vert_surface.endShape(CLOSE)
       
    def vertex_locations(self):
        # fill the array locs with corresponding img.pixels
        locs, small_locs, not_found = [], [], []
        with self.vert_surface.beginDraw(): #needed to load pixels
            # self.vert_surface.background(150, 50)
            self.vert_surface.loadPixels()
            print('pixels len:   ', len(self.vert_surface.pixels))
            for loc_x in range(self.vert_surface.width):
                for loc_y in range(self.vert_surface.height):
                    loc = loc_x + loc_y * self.vert_surface.width
                    c = self.vert_surface.pixels[loc]
                    #if a pixel has the color v.col copy its location
                    if c == self.v_col:
                        # recalculate location by adding the x and y offset (min(xs/ys)) and using the width of the image (self.w)
                        print("found x {}  found y {}".format(loc_x, loc_y))
                        loc = (loc_x + min(self.xs)) + (loc_y + min(self.ys)) * self.w 
                        locs.append(loc)
                        x1 = loc_x - min(self.xs)
                        y1 = loc_y - min(self.ys)
                        small_locs.append(x1 + y1 * self.vert_surface.width)
                    else:
                        print("not found x {}  found y {}  color {} ".format(loc_x, loc_y, c))
                        not_found.append(color(c))
        print("notfound   {}  locs  {}".format(len(not_found), len(locs)))
        return locs, small_locs
    
    def calculate_angle(self) :
        self.direction = PVector.sub(self.vectors[1], self.vectors[0])
        # self.vector.normalize()
        ref_vector = PVector(10, 0)
        # print("self vec {}  ref vect {}".format(self.direction, ref_vector))
        stroke(255,0,0)
        angle = PVector.angleBetween(self.direction, ref_vector)
        return angle
