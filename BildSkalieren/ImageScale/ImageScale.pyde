key_color = 10

def setup():
    size(1000, 850)
    global pic
    pic = loadImage("DSC05212.JPG")
    frameRate(12)
    
    
def draw():
    global pic, key_color
    image(pic, 0, 0, width, height)
    key_color += 1
    print(key_color)
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
