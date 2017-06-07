import numpy as np
import cv2
import glob
import xml.etree.ElementTree as ET

#read config file
tree = ET.parse('config_img.xml')
root = tree.getroot()
criteria = (cv2.TERM_CRITERIA_EPS + cv2.TERM_CRITERIA_MAX_ITER, 30, 0.001)
mode= root.find('mode').attrib['name']
ww=int(root.find('wind_width').text)
wh=int(root.find('wind_height').text)
bw=int(root.find('mode').find('board_width').text)
bh=int(root.find('mode').find('board_height').text)
sel_img=root.find('mode').find('sel_img').text

if mode=='img':
    images = glob.glob('*.jpg')
    
if mode=='vid':
    vid=root.find('mode').find('vid').text
    vidcap = cv2.VideoCapture(vid)
    success,image = vidcap.read()
    # image is an array of array of [R,G,B] values
    count = 0; 
    while success:
        success,image = vidcap.read()
        if count%25==0 and image!=None:
            cv2.imwrite("frame%d.jpg" % count, image)     # save frame as JPEG file
            if cv2.waitKey(10) == 27:                     # exit if Escape is hit
                break
        count += 1
    images = glob.glob('*.jpg')


# prepare object points, like (0,0,0), (1,0,0), (2,0,0) ....,(6,5,0)
objp = np.zeros((bh*bw,3), np.float32)
objp[:,:2] = np.mgrid[0:bw,0:bh].T.reshape(-1,2)
# Arrays to store object points and image points from all the images.
objpoints = [] # 3d point in real world space
imgpoints = [] # 2d points in image plane.



for image in images:
    img = cv2.imread(image)
    gray=cv2.imread(image,0)

    # Find the chess board corners
    ret, corners = cv2.findChessboardCorners(gray, (bw,bh),None)
     
    # If found, add object points, image points (after refining them)
    if ret == True:
        objpoints.append(objp)
        corners2=cv2.cornerSubPix(gray,corners,(ww,wh),(-1,-1),criteria)
        imgpoints.append(corners)

        # Draw and display the corners
        cv2.drawChessboardCorners(img, (bw,bh), corners2,ret)
        cv2.namedWindow('img', cv2.WINDOW_NORMAL)
        cv2.resizeWindow('img', 600, 400);
        cv2.imshow('img',img)
        cv2.waitKey(1000) & 0xFF
cv2.destroyAllWindows()


ret, mtx, dist, rvecs, tvecs = cv2.calibrateCamera(objpoints, imgpoints, gray.shape[::-1],None,None)

img = cv2.imread(sel_img)
h,  w = img.shape[:2]

# undistort
dst = cv2.undistort(img, mtx, dist, None)
cv2.namedWindow('img', cv2.WINDOW_NORMAL)
cv2.resizeWindow('img', 600, 400)
cv2.imshow('img',dst)
cv2.waitKey(5000) & 0xFF
cv2.destroyAllWindows()

#extrinsic parameters
o = np.squeeze(np.asarray(objpoints))
i = np.squeeze(np.asarray(imgpoints))
op = np.reshape(o, (-1, 3))
ip = np.reshape(i, (-1, 2))
ret, Ervec, Etvec=cv2.solvePnP(op, ip, mtx, dist)
rot,jacMat = cv2.Rodrigues(Ervec)

print ("rotation vector:")
print (Ervec)
print ("translation vector:")
print (Etvec)

#store camera features
oroot=ET.Element('results')
odist=ET.SubElement(oroot,'dist')
odist.text=np.array_str(dist)
omat=ET.SubElement(oroot,'camera')
omat.text=np.array_str(mtx)

tree = ET.ElementTree(oroot)
tree.write("output.xml")
