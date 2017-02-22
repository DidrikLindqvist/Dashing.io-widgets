# https://github.com/DidrikLindqvist/Dashing.io-widgets
import time
import sys
import cv2

camera_port = 0
camera = cv2.VideoCapture(camera_port)
time.sleep(0.1)
return_value, image = camera.read()
cv2.imwrite(sys.argv[1], image)
del(camera)
