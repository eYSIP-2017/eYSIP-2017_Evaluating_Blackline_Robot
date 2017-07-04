#include "utility_functions.h"




/**************************************** UTILITY FUNCTIONS *******************************************************/
bool readImageFileNames(string filename, vector<string> &file_names) {
    FileStorage fs(filename, FileStorage::READ);
    if(!fs.isOpened()){
        cerr << "Cannot open input images file" << endl;
        return false;
    }
    
    FileNode n = fs["file_names"];
    FileNodeIterator it = n.begin(), it_end = n.end();
    
    for (; it != it_end; ++it)
        file_names.push_back((string)*it);
    
    return true;
}

bool readCalibParameters(string filename, int &calibMode, string &inputImageFile, string &video, int &camId, int &markersX, int &markersY, float &markerLength, 
	float &markerSeparation, int &dictionaryId, string &outputFile, string &detectorParameters, bool &refindStrategy, int &calibrationFlags, float &aspectRatio) {
    
    FileStorage fs(filename, FileStorage::READ);
    if(!fs.isOpened()){
        cerr << "Cannot open configuration_calibration.xml file" << endl;
        return false;
    }

    // calibMode (Required)
    if(fs["calibMode"].isNone()){ 
        cout << "Set calibMode in configuration_calibration.xml file" << endl;
        return false;
    }else{ 
        calibMode = (int)fs["calibMode"];
        cout << "calibMode : " << calibMode << endl;
    }
    if(calibMode == CALIB_IMAGES){
    	// inputImageFile (Required)
    	if((string)fs["inputImageFile"]==""){ 
        	cout << "Set inputImageFile in configuration_calibration.xml file" << endl;
        	return false;
    	}else{ 
        	inputImageFile = (string)fs["inputImageFile"];
        	cout << "inputImageFile : " << inputImageFile << endl;
    	}
    }else if(calibMode == CALIB_VIDEO){
    	// videoFile (Required)
    	if((string)fs["videoFile"]==""){ 
        	cout << "Set videoFile in configuration_calibration.xml file" << endl;
        	return false;
    	}else{ 
        	video = (string)fs["videoFile"];
        	cout << "videoFile : " << video << endl;
    	}
    }else if(calibMode == CALIB_WEBCAM){
    	// camId (Required)
    	if(fs["camId"].isNone()){ 
        	cout << "Set camId in configuration_calibration.xml file" << endl;
        	return false;
    	}else{ 
        	camId = (int)fs["camId"];
        	cout << "camId : " << camId << endl;
    	}
    }

    
    // markersX (Required)
    if(fs["markersX"].isNone()){ 
        cout << "Set markersX in configuration_calibration.xml file" << endl;
        return false;
    }else{ 
        markersX = (int)fs["markersX"];
        cout << "markersX : " <<markersX << endl;
    }

    // markersY (Required)
    if(fs["markersY"].isNone()){ 
        cout << "Set markersY in configuration_calibration.xml file" << endl;
        return false;
    }else{ 
        markersY = (int)fs["markersY"];
        cout << "markersY : " << markersY << endl;
    }

    // markerLength (Required)
    if(fs["markerLength"].isNone()){ 
        cout << "Set markerLength in configuration_calibration.xml file" << endl;
        return false;
    }else{ 
        markerLength = (float)fs["markerLength"];
        cout << "markerLength : " << markerLength << endl;
    }

    // markerSeparation (Required)
    if(fs["markerSeparation"].isNone()){ 
        cout << "Set markerSeparation in configuration_calibration.xml file" << endl;
        return false;
    }else{ 
        markerSeparation = (float)fs["markerSeparation"];
        cout << "markerSeparation : " << markerSeparation << endl;
    }

    // dictionaryId (Required)
    if(fs["dictionaryId"].isNone()){ 
        cout << "Set dictionaryId in configuration_calibration.xml file" << endl;
        return false;
    }else{ 
        dictionaryId = (int)fs["dictionaryId"];
        cout << "dictionaryId : " << dictionaryId << endl;
    }

    // outputFile (Required)
    if((string)fs["outputFile"]==""){ 
        cout << "Set outputFile in configuration_calibration.xml file" << endl;
        return false;
    }else{ 
        outputFile = (string)fs["outputFile"];
        cout << "outputFile : " << outputFile << endl;
    }

    

    // detectorParameters (Optional)
    if((string)fs["detectorParameters"]==""){ 
        detectorParameters="";
    }else{ 
        detectorParameters = (string)fs["detectorParameters"];
        cout << "detectorParameters : " << detectorParameters << endl;
    }

    // refindStrategy (Optional)
    if((string)fs["refindStrategy"]==""){ 
        refindStrategy = false;
    }else{
        string str = (string)fs["refindStrategy"];
        boost::to_lower(str); 
        if(str == "true") refindStrategy=true;
        else refindStrategy=false;
        cout << "refindStrategy : " << refindStrategy << endl;
    }

    // zeroTangentialDistortion (Optional)
    if((string)fs["zeroTangentialDistortion"]!=""){ 
        string str = (string)fs["zeroTangentialDistortion"];
        boost::to_lower(str);
        if(str == "true"){ 
        	calibrationFlags |= CALIB_ZERO_TANGENT_DIST;
        	cout << "zeroTangentialDistortion : " << str << endl;
        }
    }

    // fixAspectRatio (Optional)
    if(fs["fixAspectRatio"].isNone()){ 
        aspectRatio = 1;
    }else{
    	calibrationFlags |= CALIB_FIX_ASPECT_RATIO; 
        aspectRatio = (float)fs["aspectRatio"];
        cout << "aspectRatio : " << aspectRatio << endl;
    }

    // fixPrincipalPoint (Optional)
    if((string)fs["fixPrincipalPoint"]!=""){ 
        string str = (string)fs["fixPrincipalPoint"];
        boost::to_lower(str);
        if(str == "true") {
        	calibrationFlags |= CALIB_FIX_PRINCIPAL_POINT;
        	cout << "fixPrincipalPoint : " << str << endl;
        }
    }

    return true;
}


bool readPredlocParameters(string filename, int &predlocMode, string &inputImageFile, string &video, int &camId, int &markersX, int &markersY, float &markerLength, 
    float &markerSeparation, int &dictionaryId, string &calibFile, string &detectorParameters, bool &refindStrategy, int &botDictionaryId, float &botMarkerLength) {
    
    FileStorage fs(filename, FileStorage::READ);
    if(!fs.isOpened()){
        cerr << "Cannot open configuration_predloc.xml file" << endl;
        return false;
    }

    // predlocMode (Required)
    if(fs["predlocMode"].isNone()){ 
        cout << "Set predlocMode in configuration_predloc.xml file" << endl;
        return false;
    }else{ 
        predlocMode = (int)fs["predlocMode"];
        cout << "predlocMode : " << predlocMode << endl;
    }
    if(predlocMode == PREDLOC_IMAGES){
        // inputImageFile (Required)
        if((string)fs["inputImageFile"]==""){ 
            cout << "Set inputImageFile in configuration_predloc.xml file" << endl;
            return false;
        }else{ 
            inputImageFile = (string)fs["inputImageFile"];
            cout << "inputImageFile : " << inputImageFile << endl;
        }
    }else if(predlocMode == PREDLOC_VIDEO){
        // videoFile (Required)
        if((string)fs["videoFile"]==""){ 
            cout << "Set videoFile in configuration_predloc.xml file" << endl;
            return false;
        }else{ 
            video = (string)fs["videoFile"];
            cout << "videoFile : " << video << endl;
        }
    }else if(predlocMode == PREDLOC_WEBCAM){
        // camId (Required)
        if(fs["camId"].isNone()){ 
            cout << "Set camId in configuration_predloc.xml file" << endl;
            return false;
        }else{ 
            camId = (int)fs["camId"];
            cout << "camId : " << camId << endl;
        }
    }

    
    // markersX (Required)
    if(fs["markersX"].isNone()){ 
        cout << "Set markersX in configuration_predloc.xml file" << endl;
        return false;
    }else{ 
        markersX = (int)fs["markersX"];
        cout << "markersX : " <<markersX << endl;
    }

    // markersY (Required)
    if(fs["markersY"].isNone()){ 
        cout << "Set markersY in configuration_predloc.xml file" << endl;
        return false;
    }else{ 
        markersY = (int)fs["markersY"];
        cout << "markersY : " << markersY << endl;
    }

    // markerLength (Required)
    if(fs["markerLength"].isNone()){ 
        cout << "Set markerLength in configuration_predloc.xml file" << endl;
        return false;
    }else{ 
        markerLength = (float)fs["markerLength"];
        cout << "markerLength : " << markerLength << endl;
    }

    // markerSeparation (Required)
    if(fs["markerSeparation"].isNone()){ 
        cout << "Set markerSeparation in configuration_predloc.xml file" << endl;
        return false;
    }else{ 
        markerSeparation = (float)fs["markerSeparation"];
        cout << "markerSeparation : " << markerSeparation << endl;
    }

    // dictionaryId (Required)
    if(fs["dictionaryId"].isNone()){ 
        cout << "Set dictionaryId in configuration_predloc.xml file" << endl;
        return false;
    }else{ 
        dictionaryId = (int)fs["dictionaryId"];
        cout << "dictionaryId : " << dictionaryId << endl;
    }

    // calibFile (Required)
    if((string)fs["calibFile"]==""){ 
        cout << "Set calibFile in configuration_predloc.xml file" << endl;
        return false;
    }else{ 
        calibFile = (string)fs["calibFile"];
        cout << "calibFile : " << calibFile << endl;
    }

    

    // detectorParameters (Optional)
    if((string)fs["detectorParameters"]==""){ 
        detectorParameters="";
    }else{ 
        detectorParameters = (string)fs["detectorParameters"];
        cout << "detectorParameters : " << detectorParameters << endl;
    }

    // refindStrategy (Optional)
    if((string)fs["refindStrategy"]==""){ 
        refindStrategy = false;
    }else{
        string str = (string)fs["refindStrategy"];
        boost::to_lower(str); 
        if(str == "true") refindStrategy=true;
        else refindStrategy=false;
        cout << "refindStrategy : " << refindStrategy << endl;
    }

    // BOT SPECIFIC
    // botDictionaryId (Required)
    if(fs["botDictionaryId"].isNone()){ 
        cout << "Set botDictionaryId in configuration_predloc.xml file" << endl;
        return false;
    }else{ 
        botDictionaryId = (int)fs["botDictionaryId"];
        cout << "botDictionaryId : " << botDictionaryId << endl;
    }
    // botMarkerLength (Required)
    if(fs["botMarkerLength"].isNone()){ 
        cout << "Set botMarkerLength in configuration_predloc.xml file" << endl;
        return false;
    }else{ 
        botMarkerLength = (float)fs["botMarkerLength"];
        cout << "botMarkerLength : " << botMarkerLength << endl;
    }

    return true;
}


bool readDetectorParameters(string filename, aruco::DetectorParameters &params) {
    FileStorage fs(filename, FileStorage::READ);
    if(!fs.isOpened())
        return false;
    fs["adaptiveThreshWinSizeMin"] >> params.adaptiveThreshWinSizeMin;
    fs["adaptiveThreshWinSizeMax"] >> params.adaptiveThreshWinSizeMax;
    fs["adaptiveThreshWinSizeStep"] >> params.adaptiveThreshWinSizeStep;
    fs["adaptiveThreshConstant"] >> params.adaptiveThreshConstant;
    fs["minMarkerPerimeterRate"] >> params.minMarkerPerimeterRate;
    fs["maxMarkerPerimeterRate"] >> params.maxMarkerPerimeterRate;
    fs["polygonalApproxAccuracyRate"] >> params.polygonalApproxAccuracyRate;
    fs["minCornerDistanceRate"] >> params.minCornerDistanceRate;
    fs["minDistanceToBorder"] >> params.minDistanceToBorder;
    fs["minMarkerDistanceRate"] >> params.minMarkerDistanceRate;
    fs["doCornerRefinement"] >> params.doCornerRefinement;
    fs["cornerRefinementWinSize"] >> params.cornerRefinementWinSize;
    fs["cornerRefinementMaxIterations"] >> params.cornerRefinementMaxIterations;
    fs["cornerRefinementMinAccuracy"] >> params.cornerRefinementMinAccuracy;
    fs["markerBorderBits"] >> params.markerBorderBits;
    fs["perspectiveRemovePixelPerCell"] >> params.perspectiveRemovePixelPerCell;
    fs["perspectiveRemoveIgnoredMarginPerCell"] >> params.perspectiveRemoveIgnoredMarginPerCell;
    fs["maxErroneousBitsInBorderRate"] >> params.maxErroneousBitsInBorderRate;
    fs["minOtsuStdDev"] >> params.minOtsuStdDev;
    fs["errorCorrectionRate"] >> params.errorCorrectionRate;
    return true;
}

bool saveCameraParams(const string &filename, Size imageSize, float aspectRatio, int flags,
                             const Mat &cameraMatrix, const Mat &distCoeffs, double totalAvgErr) {
    FileStorage fs(filename, FileStorage::WRITE);
    if(!fs.isOpened())
        return false;

    time_t tt;
    time(&tt);
    struct tm *t2 = localtime(&tt);
    char buf[1024];
    strftime(buf, sizeof(buf) - 1, "%c", t2);

    fs << "calibration_time" << buf;

    fs << "image_width" << imageSize.width;
    fs << "image_height" << imageSize.height;

    if(flags & CALIB_FIX_ASPECT_RATIO) fs << "aspectRatio" << aspectRatio;

    if(flags != 0) {
        sprintf(buf, "flags: %s%s%s%s",
                flags & CALIB_USE_INTRINSIC_GUESS ? "+use_intrinsic_guess" : "",
                flags & CALIB_FIX_ASPECT_RATIO ? "+fix_aspectRatio" : "",
                flags & CALIB_FIX_PRINCIPAL_POINT ? "+fix_principal_point" : "",
                flags & CALIB_ZERO_TANGENT_DIST ? "+zero_tangent_dist" : "");
    }

    fs << "flags" << flags;

    fs << "camera_matrix" << cameraMatrix;
    fs << "distortion_coefficients" << distCoeffs;

    fs << "avg_reprojection_error" << totalAvgErr;

    return true;
}

bool readCameraParameters(string filename, Mat &camMatrix, Mat &distCoeffs) {
    FileStorage fs(filename, FileStorage::READ);
    if(!fs.isOpened())
        return false;
    fs["camera_matrix"] >> camMatrix;
    fs["distortion_coefficients"] >> distCoeffs;
    return true;
}