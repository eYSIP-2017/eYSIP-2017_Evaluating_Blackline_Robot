#ifndef CALCULATE_EXTRINSIC_H
#define CALCULATE_EXTRINSIC_H

#include "utility_functions.h"

int calculateExtrinsic(vector< int > &ids, vector< vector< Point2f > > &corners, Vec3d &rvec, Vec3d &tvec, Mat image, Mat camMatrix, Mat distCoeffs, 
    					aruco::GridBoard board, aruco::Dictionary dictionary, aruco::DetectorParameters detectorParams, 
    					float axisLength, bool refindStrategy);

#endif