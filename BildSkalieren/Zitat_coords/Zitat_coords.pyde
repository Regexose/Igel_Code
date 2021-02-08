from V_Class import Vertex as v

key_color = 10
vertexes = []
coords = [(518, 118), (575, 313), (605, 306), (545, 113)]
coords2 = [(2084, 479), (2314, 1253), (2424, 1219), (2181, 449)] # original size
t = 0
        
def setup():
    size(1500, 1000)
    global pic, v, loc_v, copy_surface, v_color
    pic = loadImage("DSC05212.JPG")
    # print("pic dimensions  w  {}  h {}".format(pic.width, pic.height))
    v_color = color(0, 180, 12)
    v = v('zitat1', pic.width, pic.height, coords2, v_color)
    copy_surface = createGraphics(v.vert_surface.width, v.vert_surface.height)
    with copy_surface.beginDraw():
        copy_surface.noFill()
    frameRate(12)

def draw():
    global t, pic, v, copy_surface
    # image(pic, 0, 0, width, height)
    image(v.vert_surface, 100, 100)
    # line(518, 118, 518 + 57, 118 + 195)
    xoff = noise(t)
    yoff = noise(t)
    xoff = map(xoff, 0, 1, 0, mouseX)
    yoff = map(yoff, 0, 1, 0, mouseY)
    pushMatrix()
    translate(xoff, yoff)
    angle = random(-0.1, 0.1)
    rotate(- v.angle)
    rotate(angle)
    image(copy_surface, 0, 0)
    popMatrix()
    t += 0.02
    
def keyPressed():
    global v
    if key == 'c':
        copyPixels(v)
    if key == 'r':
        resizeSurf(v.vert_surface)

def copyPixels(v):
    global pic, copy_surface
    with copy_surface.beginDraw():
        copy_surface.loadPixels()
        pic.loadPixels()
        for index, loc in enumerate(v.locations):
            # print('index {}   loc  {} '.format(index, loc))
            copy_surface.pixels[v.vertex_locs[index]] = pic.pixels[loc]
        copy_surface.updatePixels()

def resizeSurf(surface):
    global copy_surface
    print("surface width before", copy_surface.width)
    temp_img = copy_surface.get()
    temp_img.resize(temp_img.width *4, temp_img.height *4)
    print("new width  : ", copy_surface.width)
    copy_surface = createGraphics(temp_img.width, temp_img.height)
    print("copy_surf width after", copy_surface.width)
    with copy_surface.beginDraw():
        copy_surface.image(temp_img, 0, 0)
    

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
