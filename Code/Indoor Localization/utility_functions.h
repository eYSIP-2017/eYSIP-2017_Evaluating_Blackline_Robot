#ifndef UTILITY_FUNCTIONS_H
#define UTILITY_FUNCTIONS_H

	#include <opencv2/highgui.hpp>
	#include <opencv2/calib3d.hpp>
	#include <opencv2/aruco.hpp>
	#include <opencv2/imgproc.hpp>
	#include <vector>
	#include <ctime>
	#include <iostream>
	#include <boost/algorithm/string.hpp>
	#include <fstream>

	using namespace std;
	using namespace cv;

	#define PI 3.14159265
	#define WIDTH 1080
	#define HEIGHT 720
	#define MAIN_PATH "../"
	#define INPUT_FOLDER "input_folder/"
	#define OUTPUT_FOLDER "output_folder/"
	#define CONFIG_FOLDER "config_folder/"
	#define CALIBRATION "calibration/"
	#define PREDLOC "predloc/"
	#define CALIBRATION_CONFIG_FILE "configuration_calibration.xml"
	#define PREDLOC_CONFIG_FILE "configuration_predloc.xml"
	#define STATIC_IMAGE_OUTPUT "../output_folder/static_image.csv"
	#define VIDEO_FILE_OUTPUT "../output_folder/video_file_output.csv"

	#define BOT_MARKER_ID 0
	#define BOT_HEIGHT 0.105 // in meters

	enum calibration_mode {CALIB_IMAGES, CALIB_VIDEO, CALIB_WEBCAM};
	enum predloc_mode {PREDLOC_IMAGES, PREDLOC_VIDEO, PREDLOC_WEBCAM};


	/**************************************** FUNCTION DECLARATION *******************************************************/
	bool readImageFileNames(string filename, vector<string>&);
	bool readCalibParameters(string filename, int &calibMode, string &inputImageFile, string &video, int &camId, int &markersX, int &markersY, float &markerLength, 
			float &markerSeparation, int &dictionaryId, string &outputFile, string &detectorParameters, bool &refindStrategy, int &calibrationFlags, float &aspectRatio);
	bool readPredlocParameters(string filename, int &predlocMode, string &inputImageFile, string &video, int &camId, int &markersX, int &markersY, float &markerLength, 
    		float &markerSeparation, int &dictionaryId, string &calibFile, string &detectorParameters, bool &refindStrategy, int &botDictionaryId, float &botMarkerLength);
	bool readDetectorParameters(string filename, aruco::DetectorParameters &params);
	bool saveCameraParams(const string &filename, Size imageSize, float aspectRatio, int flags, const Mat &cameraMatrix, const Mat &distCoeffs, double totalAvgErr);
	bool readCameraParameters(string filename, Mat &camMatrix, Mat &distCoeffs);
#endif