#include "utility_functions.h"
#include "calculate_extrinsic.h"
#include "detect_bot_marker.h"
#include "calculate_world_coordinate.h"

bool calculateOrientation(double &angle, vector< Point2f > worldCornerPoints){
	
	if(worldCornerPoints.size()!=4){
		cout << "Not enough corner points in calculateOrientation" << endl;
		return false;
	}

	double angle1,angle2;
	angle1 = atan2((worldCornerPoints[0].y - worldCornerPoints[3].y), (worldCornerPoints[0].x - worldCornerPoints[3].x)) * 180 / PI;
	//cout << angle1 << endl;
	angle2 = atan2((worldCornerPoints[1].y - worldCornerPoints[2].y), (worldCornerPoints[1].x - worldCornerPoints[2].x)) * 180 / PI;
	//cout << angle2 << endl;
	
	angle = (angle1 + angle2)/2;

	return true;
}

void writeToCsvFile(fstream myfile, string name, double angle, double x, double y){
    myfile << name << "," << angle << "," << x << "," << y << endl;
}


int main(int argc, char *argv[]) {

    int predlocMode;
    string inputImageFile;
    string video;
    int camId;

    // Required Parameters
    string calibFile;
    int markersX;
    int markersY;
    float markerLength;
    float markerSeparation;
    int dictionaryId;
    
    // Optional Parameters
    string detectorParameters;
    bool refindStrategy;

    // Bot Marker Parameters
    int botDictionaryId;
    float botMarkerLength;
    
    readPredlocParameters((string)MAIN_PATH + (string)CONFIG_FOLDER + (string)PREDLOC_CONFIG_FILE, predlocMode, inputImageFile, video, camId, 
        markersX, markersY, markerLength, markerSeparation, dictionaryId, calibFile, detectorParameters, refindStrategy, botDictionaryId, botMarkerLength);
    
    aruco::DetectorParameters detectorParams;
    if(detectorParameters!="") {
        bool readOk = readDetectorParameters((string)MAIN_PATH + (string)CONFIG_FOLDER + detectorParameters, detectorParams);
        if(!readOk) {
            cerr << "Invalid detector parameters file" << endl;
            return 0;
        }
    }
    detectorParams.doCornerRefinement = true; // do corner refinement in markers

    vector<string> file_names;
    VideoCapture inputVideo;
    int waitTime;
    if(predlocMode==PREDLOC_IMAGES){
        bool readOk = readImageFileNames((string)MAIN_PATH + (string)INPUT_FOLDER + (string)PREDLOC + inputImageFile, file_names);
        if(!readOk) { 
            cerr << "Invalid input images file" << endl;
            return 0;
        }
        for(int i=0; i<file_names.size(); i++){
            cout << file_names[i] << endl;
        }
    }else if(predlocMode==PREDLOC_VIDEO){
        inputVideo.open((string)MAIN_PATH + (string)INPUT_FOLDER + (string)PREDLOC + video);
        waitTime = 0;   
    }else if(predlocMode==PREDLOC_WEBCAM){
        inputVideo.open(camId);
        waitTime = 10;
    }

    Mat camMatrix, distCoeffs;
    if(calibFile!="") {
        bool readOk = readCameraParameters((string)MAIN_PATH + (string)OUTPUT_FOLDER + calibFile, camMatrix, distCoeffs);
        if(!readOk) {
            cerr << "Invalid camera file" << endl;
            return 0;
        }
    }

    aruco::Dictionary dictionary =
        aruco::getPredefinedDictionary(aruco::PREDEFINED_DICTIONARY_NAME(dictionaryId));

    // create board object
    aruco::GridBoard board = aruco::GridBoard::create(markersX, markersY, markerLength, markerSeparation, dictionary);

    float axisLength = 0.5f * ((float)min(markersX, markersY) * (markerLength + markerSeparation) + markerSeparation);

    
    if(predlocMode==PREDLOC_IMAGES){
    	
    	fstream fs;
		fs.open(STATIC_IMAGE_OUTPUT, std::fstream::app);
    	fs <<"Image Name" << "," << "Observed Angle(Degree)" << "," << "Observed X(cm)" << "," << "Observed Y(cm)" << endl;
        
        for(int i=0; i<file_names.size(); i++){
            
            Mat image, imageCopy;
            image = imread((string)MAIN_PATH + (string)INPUT_FOLDER + (string)PREDLOC + file_names[i], CV_LOAD_IMAGE_COLOR);
            cout << "PROCESSING IMAGE : " << file_names[i] << endl;
            
            // Calculate Extrinsic Parameters
            vector< int > boardIds; 
            vector< vector< Point2f > > boardCorners;
            Vec3d rvec, tvec;
            int validPose = calculateExtrinsic(boardIds, boardCorners, rvec, tvec, image, camMatrix, distCoeffs, board, dictionary, 
                                detectorParams, axisLength, refindStrategy);

            if(validPose<=0){
            	//cout << "Cannot estimate pose for Image : " << file_names[i] << endl;
            	continue;
            }

            // Draw detected board markers and axis
            if(validPose>0){
                image.copyTo(imageCopy);
                aruco::drawDetectedMarkers(imageCopy, boardCorners, boardIds);
                aruco::drawAxis(imageCopy, camMatrix, distCoeffs, rvec, tvec, axisLength);
            }

            // Detect Bot Marker
            vector< int > botMarkerIds;
            vector< vector< Point2f > > botMarkerCorners;
            bool validMarker  = detectBotMarker(botMarkerIds, botMarkerCorners, image, botDictionaryId, botMarkerLength, detectorParams, calibFile);
            if(!validMarker){
            	//cout << "Cannot detect bot marker for Image : " << file_names[i] << endl;
            	continue;
            }

            if(validMarker){
                aruco::drawDetectedMarkers(imageCopy, botMarkerCorners, botMarkerIds);
            }

            /*int index = -1;
            for(int j=0; j<boardIds.size(); j++){
            	if(boardIds[j] == 22){
            		index = j;	
            		break;
            	}
            }
            
            if(index == -1){
            	cout << "Index not found. Skipping" << endl;
            	//continue;
            }*/

            vector< Point3f > axisPoints;
    		axisPoints.push_back(Point3f(0, 0, 0));
    		vector< Point2f > imagePoints;
    		projectPoints(axisPoints, rvec, tvec, camMatrix, distCoeffs, imagePoints);

    		if(validPose && validMarker){
            //if(validPose && validMarker && index!=-1){
            	vector< Point2f > worldCornerPoints;
            	//bool validBotLoc = calculateWorldCoordinate(worldCornerPoints, boardCorners[index][3], botMarkerCorners[0], rvec, tvec, camMatrix, distCoeffs);
            	bool validBotLoc = calculateWorldCoordinate(worldCornerPoints, imagePoints[0], botMarkerCorners[0], rvec, tvec, camMatrix, distCoeffs);
            	//cout << "validBotLoc : " << validBotLoc << endl;
            	if(validBotLoc){
            		double botCenterX=0, botCenterY=0;
            		for(int k=0; k<4; k++){
            			worldCornerPoints[k] = worldCornerPoints[k]*100;
            			botCenterX += worldCornerPoints[k].x;
            			botCenterY += worldCornerPoints[k].y; 
            		}

            		Point2f botloc(botCenterX/4,botCenterY/4);
            		cout << "botloc : " << botloc << endl;

            		double angle;
            		bool validAngle = calculateOrientation(angle, worldCornerPoints);
            		
            		if(validAngle){
            			cout << "angle : " << angle << endl;
            			fs << file_names[i] << "," << angle << "," << botloc.x << "," << botloc.y << endl;
            		}
            	}

            }

            // Display Image
            namedWindow( "Extrinsic", WINDOW_NORMAL );
            resizeWindow("Extrinsic", WIDTH, HEIGHT);
            imshow("Extrinsic", imageCopy);
            char key = (char)waitKey(0);
            if(key == 27) break;
        }
        fs.close();
    }else {
    	int frameCount = 0;
    	fstream fs;
		fs.open(VIDEO_FILE_OUTPUT, std::fstream::app);
    	fs <<"Frame No" << "," << "Observed Angle(Degree)" << "," << "Observed X(cm)" << "," << "Observed Y(cm)" << "," << "Time(s)"<<endl;

    	//while(inputVideo.grab() && (frameCount<5)) {
    	while(inputVideo.grab()) {
    		Mat image, imageCopy;
            inputVideo.retrieve(image);
            cout << "PROCESSING Frame : " << frameCount << endl;
            
            // Calculate Extrinsic Parameters
            vector< int > boardIds; 
            vector< vector< Point2f > > boardCorners;
            Vec3d rvec, tvec;
            int validPose = calculateExtrinsic(boardIds, boardCorners, rvec, tvec, image, camMatrix, distCoeffs, board, dictionary, 
                                detectorParams, axisLength, refindStrategy);
            if(validPose<=0){
            	//cout << "Cannot estimate pose for Frame no : " << frameCount << endl;
            	frameCount++;
            	continue;
            }

            // Draw detected board markers and axis
            //if(validPose>0 && (frameCount==70)){
            if(validPose>0 && (frameCount%100==0)){
                //cout << rvec << endl;
                //cout << tvec << endl;
                image.copyTo(imageCopy);
                aruco::drawDetectedMarkers(imageCopy, boardCorners, boardIds);
                aruco::drawAxis(imageCopy, camMatrix, distCoeffs, rvec, tvec, axisLength);
            }

            // Detect Bot Marker
            vector< int > botMarkerIds;
            vector< vector< Point2f > > botMarkerCorners;
            bool validMarker  = detectBotMarker(botMarkerIds, botMarkerCorners, image, botDictionaryId, botMarkerLength, detectorParams, calibFile);
            if(!validMarker){
            	//cout << "Cannot detect bot marker for Frame no : " << frameCount << endl;
            	frameCount++;
            	continue;
            }

            // Draw detected bot marker
            //if(validMarker && (frameCount==70)){
            if(validMarker && (frameCount%100==0)){
                aruco::drawDetectedMarkers(imageCopy, botMarkerCorners, botMarkerIds);
            }

            /*int index = -1;
            for(int j=0; j<boardIds.size(); j++){
            	if(boardIds[j] == 22){
            		index = j;	
            		break;
            	}
            }
            
            if(index == -1){
            	cout << "Index not found. Skipping" << endl;
            	frameCount++;
            	continue;
            }*/

            vector< Point3f > axisPoints;
    		axisPoints.push_back(Point3f(0, 0, 0));
    		vector< Point2f > imagePoints;
    		projectPoints(axisPoints, rvec, tvec, camMatrix, distCoeffs, imagePoints);

    		if(validPose && validMarker){
            //if(validPose && validMarker && index!=-1){
            	vector< Point2f > worldCornerPoints;
            	//bool validBotLoc = calculateWorldCoordinate(worldCornerPoints, boardCorners[index][3], botMarkerCorners[0], rvec, tvec, camMatrix, distCoeffs);
            	bool validBotLoc = calculateWorldCoordinate(worldCornerPoints, imagePoints[0], botMarkerCorners[0], rvec, tvec, camMatrix, distCoeffs);

            	if(validBotLoc){
            		double botCenterX=0, botCenterY=0;
            		for(int k=0; k<4; k++){
            			worldCornerPoints[k] = worldCornerPoints[k]*100;
            			botCenterX += worldCornerPoints[k].x;
            			botCenterY += worldCornerPoints[k].y; 
            		}

            		Point2f botloc(botCenterX/4,botCenterY/4);
            		cout << "botloc : " << botloc << endl;

            		double angle;
            		bool validAngle = calculateOrientation(angle, worldCornerPoints);
            		
            		if(validAngle){
            			cout << "angle : " << angle << endl;
            			fs << frameCount << "," << angle << "," << botloc.x << "," << botloc.y << "," << inputVideo.get(CV_CAP_PROP_POS_MSEC)/1000 << endl;
            		}
            	}
            }
            //if(frameCount==70){
            if(frameCount%100==0){
            	// Display Image
            	namedWindow( "Extrinsic", WINDOW_NORMAL );
            	resizeWindow("Extrinsic", WIDTH, HEIGHT);
            	imshow("Extrinsic", imageCopy);
            	char key = (char)waitKey(0);
            	if(key == 27) break;
            }
            frameCount++;
    	}
    	fs.close();
    	inputVideo.release();
    }
    	
    return 0;
}