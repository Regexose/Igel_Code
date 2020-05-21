

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
            r = red(pixels[loc])
            g = green(pixels[loc])
            b = blue(pixels[loc])
            
            if r < 83 and g < 83 and b < 83:
                pixels[loc] = color(255, 0, 0)
    updatePixels()
