#include "utility_functions.h"




/**
 */
int main(int argc, char *argv[]) {

    int calibMode;
    string inputImageFile;
    string video;
    int camId;
    // Required Parameters
    string outputFile;
    int markersX;
    int markersY;
    float markerLength;
    float markerSeparation;
    int dictionaryId;

    // Optional Parameters
    string detectorParameters;
    bool refindStrategy;
    int calibrationFlags = 0;
    float aspectRatio = 1;
    bool showChessboardCorners;

    readCalibParameters((string)MAIN_PATH + (string)CONFIG_FOLDER + (string)CALIBRATION_CONFIG_FILE, calibMode, inputImageFile, video, camId, markersX, markersY, markerLength, 
        markerSeparation, dictionaryId, outputFile, detectorParameters, refindStrategy, 
        calibrationFlags, aspectRatio);

    aruco::DetectorParameters detectorParams;
    if(detectorParameters!="") {
        bool readOk = readDetectorParameters((string)MAIN_PATH + (string)CONFIG_FOLDER + detectorParameters, detectorParams);
        if(!readOk) {
            cerr << "Invalid detector parameters file" << endl;
            return 0;
        }
    }

    vector<string> file_names;
    VideoCapture inputVideo;
    int waitTime;
    if(calibMode==CALIB_IMAGES){
        bool readOk = readImageFileNames((string)MAIN_PATH + (string)INPUT_FOLDER + (string)CALIBRATION + inputImageFile, file_names);
        if(!readOk) {
            cerr << "Invalid input images file" << endl;
            return 0;
        }
        for(int i=0; i<file_names.size(); i++){
            cout << file_names[i] << endl;
        }
    }else if(calibMode==CALIB_VIDEO){
        inputVideo.open((string)MAIN_PATH + (string)INPUT_FOLDER + (string)CALIBRATION + video);
        waitTime = 0;   
    }else if(calibMode==CALIB_WEBCAM){
        inputVideo.open(camId);
        waitTime = 10;
    }

    aruco::Dictionary dictionary =
        aruco::getPredefinedDictionary(aruco::PREDEFINED_DICTIONARY_NAME(dictionaryId));

    // create board object
    aruco::GridBoard board =
        aruco::GridBoard::create(markersX, markersY, markerLength, markerSeparation, dictionary);

    // collected frames for calibration
    vector< vector< vector< Point2f > > > allCorners;
    vector< vector< int > > allIds;
    Size imgSize;

    if(calibMode == CALIB_IMAGES){
        for(int i=0; i<file_names.size(); i++){
            Mat image, imageCopy;
            image = imread((string)MAIN_PATH + (string)INPUT_FOLDER + (string)CALIBRATION + file_names[i], CV_LOAD_IMAGE_COLOR);
            
            vector< int > ids;
            vector< vector< Point2f > > corners, rejected;
            
            // detect markers
            aruco::detectMarkers(image, dictionary, corners, ids, detectorParams, rejected);

            // refind strategy to detect more markers
            if(refindStrategy) aruco::refineDetectedMarkers(image, board, corners, ids, rejected);
            
            // draw results
            image.copyTo(imageCopy);
            if(ids.size() > 0) aruco::drawDetectedMarkers(imageCopy, corners, ids);
            putText(imageCopy, "Press 'c' to use, 's' to skip this image for calibration. 'ESC' to finish and calibrate",
                Point(10, 20), FONT_HERSHEY_SIMPLEX, 0.5, Scalar(255, 0, 0), 2);

            namedWindow( "Input Image", WINDOW_NORMAL );
            resizeWindow("Input Image", WIDTH, HEIGHT);
            imshow("Input Image", imageCopy);

            char key = (char)waitKey(waitTime);
            if(key == 27) break;
            if(key == 's') continue;
            if(key == 'c' && ids.size() > 0) {
                cout << "Frame captured" << endl;
                allCorners.push_back(corners);
                allIds.push_back(ids);
                imgSize = image.size();
                /*if(ids.size()>0){
                    cout << "\nDetected ids and corners : " << endl;
                    for(int i=0; i<ids.size(); i++){
                        cout << "id = "<< ids[i] << endl;
                        for(int j=0; j<corners[i].size(); j++){
                            cout << corners[i][j] << " ";
                        }
                        cout << endl;
                    }
                }*/
            }
        }
    }else {
        while(inputVideo.grab()) {
            Mat image, imageCopy;
            inputVideo.retrieve(image);

            vector< int > ids;
            vector< vector< Point2f > > corners, rejected;

            // detect markers
            aruco::detectMarkers(image, dictionary, corners, ids, detectorParams, rejected);

            // refind strategy to detect more markers
            if(refindStrategy) aruco::refineDetectedMarkers(image, board, corners, ids, rejected);

            // draw results
            image.copyTo(imageCopy);
            if(ids.size() > 0) aruco::drawDetectedMarkers(imageCopy, corners, ids);
            putText(imageCopy, "Press 'c' to use, 's' to skip this image for calibration. 'ESC' to finish and calibrate",
                Point(10, 20), FONT_HERSHEY_SIMPLEX, 0.5, Scalar(255, 0, 0), 2);

            namedWindow( "Input Image", WINDOW_NORMAL );
            resizeWindow("Input Image", WIDTH, HEIGHT);
            imshow("Input Image", imageCopy);

            char key = (char)waitKey(waitTime);
            if(key == 27) break;
            if(key == 's') continue;
            if(key == 'c' && ids.size() > 0) {
                cout << "Frame captured" << endl;
                allCorners.push_back(corners);
                allIds.push_back(ids);
                imgSize = image.size();
            }
        }
    }

    if(allIds.size() < 1) {
        cerr << "Not enough captures for calibration" << endl;
        return 0;
    }

    Mat cameraMatrix, distCoeffs;
    vector< Mat > rvecs, tvecs;
    double repError;

    if(calibrationFlags & CALIB_FIX_ASPECT_RATIO) {
        cameraMatrix = Mat::eye(3, 3, CV_64F);
        cameraMatrix.at< double >(0, 0) = aspectRatio;
    }

    // prepare data for calibration
    vector< vector< Point2f > > allCornersConcatenated;
    vector< int > allIdsConcatenated;
    vector< int > markerCounterPerFrame;
    markerCounterPerFrame.reserve(allCorners.size());
    for(unsigned int i = 0; i < allCorners.size(); i++) {
        markerCounterPerFrame.push_back((int)allCorners[i].size());
        for(unsigned int j = 0; j < allCorners[i].size(); j++) {
            allCornersConcatenated.push_back(allCorners[i][j]);
            allIdsConcatenated.push_back(allIds[i][j]);
        }
    }
    // calibrate camera
    repError = aruco::calibrateCameraAruco(allCornersConcatenated, allIdsConcatenated,
                                           markerCounterPerFrame, board, imgSize, cameraMatrix,
                                           distCoeffs, rvecs, tvecs, calibrationFlags);

    bool saveOk = saveCameraParams((string)MAIN_PATH + (string)OUTPUT_FOLDER + outputFile, imgSize, aspectRatio, calibrationFlags, cameraMatrix,
                                   distCoeffs, repError);

    if(!saveOk) {
        cerr << "Cannot save output file" << endl;
        return 0;
    }

    cout << "Rep Error: " << repError << endl;
    cout << "Calibration saved to " << outputFile << endl;

    return 0;
}
