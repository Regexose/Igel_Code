

def setup():
    size(1000, 850)
    global pic
    pic = loadImage("DSC05212.JPG")
    
    
def draw():
    global pic
    image(pic, 0, 0, width, height)
    changePixels()
    
def changePixels():
    loadPixels()
    for x in range(width):
        for y in range(height):
            loc = x + y * width
            if (x % 2 == 0):
                pixels[loc] = color(255 - mouseX)
            else:
                pixels[loc] = color(0 + mouseY)
    updatePixels()
