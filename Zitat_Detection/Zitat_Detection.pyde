threshold = 180
vert = 0
horiz = 0

def setup():
    size(800,600)
    global img_zitat, img_plansche
    img_zitat = loadImage("DSC05212.JPG")
    img_plansche = loadImage("Ort_DSC05036_plWeyde.jpg")
    


def draw():
    global img_zitat, img_plansche, threshold, vert, horiz
    image(img_zitat, 0,0, width, height)
    loadPixels()
    for x in range(width):
        for y in range(height):
            loc = x + y * width
            b = brightness(pixels[loc])
            if b > threshold:
                pixels[loc] = color(255)
                vert = 0
                horiz = 0
            elif (vert >= 4 or horiz >= 4) and b < threshold:
                pixels[loc] = color(0, 255, 0)
                vert += 1
                horiz += 1
            else: 
                pixels[loc] = color(255, 0, 0)
                vert += 1
                horiz += 1
    updatePixels()
    
def stop():
    saveFrame("Zitate2.png")
    pass

      
      
