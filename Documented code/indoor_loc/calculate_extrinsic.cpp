#include "calculate_extrinsic.h"

/**
 */
int calculateExtrinsic(vector< int > &ids, vector< vector< Point2f > > &corners, Vec3d &rvec, Vec3d &tvec, Mat image, Mat camMatrix, Mat distCoeffs, 
    aruco::GridBoard board, aruco::Dictionary dictionary, aruco::DetectorParameters detectorParams, float axisLength, bool refindStrategy) {

    //Mat imageCopy;

    //vector< int > ids;
    vector< vector< Point2f > > rejected;

    // detect markers
    aruco::detectMarkers(image, dictionary, corners, ids, detectorParams, rejected);

    // refind strategy to detect more markers
    if(refindStrategy)
        aruco::refineDetectedMarkers(image, board, corners, ids, rejected, camMatrix, distCoeffs);


    // estimate board pose
    int markersOfBoardDetected = 0;
    if(ids.size() > 0)
        markersOfBoardDetected = aruco::estimatePoseBoard(corners, ids, board, camMatrix, distCoeffs, rvec, tvec);

    // draw results
    //image.copyTo(imageCopy);
    //if(ids.size() > 0) {
    //    aruco::drawDetectedMarkers(imageCopy, corners, ids);
    //}

    //if(showRejected && rejected.size() > 0)
    //    aruco::drawDetectedMarkers(imageCopy, rejected, noArray(), Scalar(100, 0, 255));

    //if(markersOfBoardDetected > 0)
    //    aruco::drawAxis(imageCopy, camMatrix, distCoeffs, rvec, tvec, axisLength);

    //namedWindow( "Extrinsic", WINDOW_NORMAL );
    //resizeWindow("Extrinsic", WIDTH, HEIGHT);
    //imshow("Extrinsic", imageCopy);
    //char key = (char)waitKey(0);
    //if(key == 27) return markersOfBoardDetected;

    return markersOfBoardDetected;
}
