from Surfaces import *
import os

add_library('opencv_processing')

# BASE_DIR = os.path.dirname(os.path.abspath(__file__))
BASE_DIR = str(this.dataFile(''))
SKETCH_PATH = os.listdir('.')
DATA_FOLDER = this.dataPath('') + '/'
# image_path = this.listPaths(BASE_DIR.path, 'extensions=,jpg, png')

print('base: ', BASE_DIR)
print('sketch: ', SKETCH_PATH)
print('data folder: ', DATA_FOLDER)

for name in os.listdir(BASE_DIR):
    path = os.path.join(BASE_DIR, name)
    if os.path.isdir(path):
        print(path)

scales = {}

threshold = 180
vert = 0
horiz = 0
vertex_shapes = []

def setup():
    size(1000,800)
    global img_zitat, img_plansche, opencv, contours, fill_color
    img_zitat = loadImage("DSC05212.JPG")
    img_zitat.resize(width, height)
    img_plansche = loadImage("Ort_DSC05036_plWeyde.jpg")
    surface = createGraphics(width, height)
    with surface.beginDraw():
        surface.image(img_zitat, 0, 0, surface.width, surface.height)
    opencv = OpenCV(this, img_zitat)
    opencv.threshold(70)
    dst = opencv.getOutput()
    contours = opencv.findContours()
    print("found {} contours".format(len(contours)))

def draw():
    global img_zitat, threshold, vert, horiz, opencv, contours
    image(img_zitat, 0, 0)
    # image(dst, width/2 ,0)
    noFill()
    strokeWeight(1)
    for contour in contours:
        # stroke(0, 255, 0)
        # contour.draw()
        fill_color = color(255-random(250), 255-random(250), 255-random(250))
        # stroke(255, 0, 0)
        beginShape()
        contour.setPolygonApproximationFactor(3.0)
        for p in contour.getPolygonApproximation().getPoints():
            fill(fill_color)
            vertex(p.x, p.y)
        endShape(CLOSE)
    
    # loadPixels()
    # for x in range(width):
    #     for y in range(height):
    #         loc = x + y * width
    #         b = brightness(pixels[loc])
    #         if b > threshold:
    #             pixels[loc] = color(255)
    #             vert = 0
    #             horiz = 0
    #         elif (vert >= 4 or horiz >= 4) and b < threshold:
    #             pixels[loc] = color(0, 255, 0)
    #             vert += 1
    #             horiz += 1
    #         else: 
    #             pixels[loc] = color(255, 0, 0)
    #             vert += 1
    #             horiz += 1
    # updatePixels()
    
def stop():
    saveFrame("Zitate2.png")
    pass

def loadScales(folder):
    pass
    '''
    pseudocode
    # filenames = list(folder)
    for file in folder:
        name = file.name
        opencv = OpenCV(this, img)
        scales[file.name] = AugmentedImage(name, img, opencv) 
    '''
        
    
      
      
