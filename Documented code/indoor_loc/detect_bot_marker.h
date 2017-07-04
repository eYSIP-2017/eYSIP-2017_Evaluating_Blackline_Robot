#ifndef DETECT_BOT_MARKER_H
#define DETECT_BOT_MARKER_H

#include "utility_functions.h"

bool detectBotMarker(vector<int> &botMarkerId, vector< vector< Point2f > > &botMarkerCorners, Mat image, int dictionaryId, float markerLength, 
	aruco::DetectorParameters detectorParams, string calibFile);

#endif