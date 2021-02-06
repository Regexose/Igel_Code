from V_Class import Vertex as v

key_color = 10
vertexes = []
coords = [(518, 118), (575, 313), (605, 306), (545, 113)]
t = 0
        
def setup():
    size(1500, 1000)
    global pic, v, loc_v, copy_surface, v_color
    pic = loadImage("DSC05212.JPG")
    v_color = color(0, 180, 12)
    v = v('zitat1', coords, v_color)
    copy_surface = createGraphics(v.vert_surface.width, v.vert_surface.height)
    with copy_surface.beginDraw():
        copy_surface.noFill()
    frameRate(12)

    
def draw():
    global t, pic, v, copy_surface
    image(pic, 0, 0, width, height)
    line(518, 118, 518 + 57, 118 + 195)
    if keyPressed :
        copyPixels(v)
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
