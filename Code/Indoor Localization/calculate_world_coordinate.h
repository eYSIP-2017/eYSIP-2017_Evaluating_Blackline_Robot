#ifndef CALCULATE_WORLD_COORDINATE_H
#define CALCULATE_WORLD_COORDINATE_H

#include "utility_functions.h"

int convertToWorldCoordinate(vector< Point2f > &worldPoints, vector< Point2f > imagePoints, double Zw, Mat rMat, Mat camMatrix, Vec3d tvec);
bool calculateWorldCoordinate(vector< Point2f > &worldCornerPoints, Point2f originPoint, vector< Point2f > imagePoints, Vec3d rvec, Vec3d tvec, Mat camMatrix, Mat distCoeffs);

#endif