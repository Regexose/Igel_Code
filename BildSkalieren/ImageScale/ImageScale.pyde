

def setup():
    size(1000, 850)
    global pic
    pic = loadImage("DSC05212.JPG")
    
def draw():
    global pic
    image(pic, 0, 0, width, height)
