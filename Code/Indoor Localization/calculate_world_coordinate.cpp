#include "calculate_world_coordinate.h"

int convertToWorldCoordinate(vector< Point2f > &worldPoints, vector< Point2f > imagePoints, double Zw, Mat rMat, Mat camMatrix, Vec3d tvec){

	double fx,fy,cx,cy;
	double r11,r12,r13,r21,r22,r23,r31,r32,r33;
	double t1,t2,t3;

	fx = camMatrix.at<double>(0,0);
	fy = camMatrix.at<double>(1,1);
	cx = camMatrix.at<double>(0,2);
	cy = camMatrix.at<double>(1,2);

	r11 = rMat.at<double>(0,0);
	r12 = rMat.at<double>(0,1);
	r13 = rMat.at<double>(0,2);
	r21 = rMat.at<double>(1,0);
	r22 = rMat.at<double>(1,1);
	r23 = rMat.at<double>(1,2);
	r31 = rMat.at<double>(2,0);
	r32 = rMat.at<double>(2,1);
	r33 = rMat.at<double>(2,2);

	t1 = tvec[0];
	t2 = tvec[1];
	t3 = tvec[2];

	for(int i=0; i<imagePoints.size(); i++){
		double u, v;
		u = imagePoints[i].x;
		v = imagePoints[i].y;

		Mat_<double> A(2, 2, 0.0 );

		A.at<double>(0,0) = (u - cx)*r31 - fx*r11;
		A.at<double>(0,1) = (u - cx)*r32 - fx*r12;
		A.at<double>(1,0) = (v - cy)*r31 - fy*r21;
		A.at<double>(1,1) = (v - cy)*r32 - fy*r22;
		
		Mat_<double> B(2, 1, 0.0 );
		B.at<double>(0,0) = Zw*(fx*r13 + (cx - u)*r33) + fx*t1 + (cx - u)*t3;
		B.at<double>(1,0) = Zw*(fy*r23 + (cy - v)*r33) + fy*t2 + (cy - v)*t3;

		Mat C = A.inv()*B;
		Point2f p(C.at<double>(0,0), C.at<double>(0,1));
		worldPoints.push_back(p);
		
	}

	return 0;
}

bool calculateWorldCoordinate(vector< Point2f > &worldCornerPoints, Point2f originPoint, vector< Point2f > imagePoints, Vec3d rvec, Vec3d tvec, Mat camMatrix, Mat distCoeffs){

	if(imagePoints.size()!=4){
		cout << "Not enough corner points in calculateWorldCoordinate" << endl;
		return false;
	}

	Mat rMat;
	Rodrigues(rvec, rMat);
	
	vector<Point2f> originPoints, worldOriginPoints;
	originPoints.push_back(originPoint);
	convertToWorldCoordinate(worldOriginPoints, originPoints, 0.0, rMat, camMatrix, tvec);

	vector<Point2f> worldImagePoints;
	convertToWorldCoordinate(worldImagePoints, imagePoints, BOT_HEIGHT, rMat, camMatrix, tvec);
	
	for(int i=0; i<worldImagePoints.size(); i++){
		worldCornerPoints.push_back(worldImagePoints[i] - worldOriginPoints[0]);
		//cout << worldCornerPoints[i] << endl;
	}

	return true;
}
