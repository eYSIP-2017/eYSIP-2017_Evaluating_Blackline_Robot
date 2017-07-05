# eYSIP-2017_Evaluating_Blackline_Robot
This project develops a video analytic software system for automatic eval-
uation of videos of robots following black line in the e-yantra competitions.

The videos are taken using unknown camera while the robot moves over

predefined arena of fixed dimensions. The arena as well as the robot are

labelled with ArUco markers (see Figure 1.1). Robot motion trajectory was

extracted from the video by doing camera calibration, pose estimation and

localization. Next, the trajectory is evaluated by computing the average de-
viation from an ideal path. The trajectory extraction was implemented in

C++ using OpenCV 3.1.0 while trajectory evaluation was done in MATLAB.

Experiments were carried out to measure the accuracy which showed that

the robot can be localized to about 1 cm accuracy on a 6X6 feet arena from

a video captured on mobile phones. An automatic evaluation of videos of

black line following robots was carried out and found to match the human

evaluation.
