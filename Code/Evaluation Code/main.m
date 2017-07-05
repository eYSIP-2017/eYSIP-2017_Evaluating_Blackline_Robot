%{
This is the main function which Compares all the video files(.txt or .csv ones) and displays the result at the end.
1.Before running the main file Check
  * the Output files(.txt or .csv) of video are named number.txt or number.csv ex- 1.txt,2.txt,3.txt etc. in the order which is known
  * the Output files(.txt or .csv) of video is in the format [Frameno,Orientation,X,Y,Time] (',' or space)
  * the Ideal file is in format [X(in cm),Y(in cm),PreviousNode,NextNode,BranchName] (',' or space)
  * if X and Y of ideal file is in pixel then run IdealSample.m to sample and change pixels to centimeters(cms)
  * and all are in the same directory
%}
clear;
clc;
List(1,1) = 0;% Initialise the List to store the errors
no_of_files = input('Total Number of videos to compute - ');% Total no of video files in the above directory
width = input(' Enter the window size (diameter in cm) - ');% Window size  
Ideal = Idealsort(); % Function to Sort the ideal file according to different nodes as a 4-D Matrix
                     % Ideal(PreviousNode,NextNode,X-cordinate,Ycordinate,Weightofnode)
Weight = Weigh(Ideal);% Create Adjacency matrix
for i = 1:no_of_files % for all Video files
    disp('.')
    disp('.')
    pVideo = strcat('Comparing Video ',num2str(i));% display which video its been processed
    disp(pVideo)
    %filename = strcat(num2str(i),'.txt'); %if the files are in .txt format
    %P = dlmread(filename); % get it from txt and save it in P
    filename = strcat(num2str(i),'.csv');%if the files are in .csv format
    P = csvread(filename);% get information from .csv and save it in P
    out = Compare(P,width,Ideal,Weight);% out has out = [total_accumulated_error,total_time_taken,skipped_distance,Flag_for_completed_runs]
    tot_dist = out(1);
    tot_errortime = out(2);
    tot_skip_dist = out(3);
    Completed = out(4);
    Total = 10000.*(1./tot_dist) + 3000.*(1./tot_errortime) + 100.*(1./tot_skip_dist); %finding total with different gains
    %List = dlmread('list.txt'); % if need to store it in a file
    %list_len = length(List);
    List(i,1) = i;
    List(i,2) = tot_dist;
    List(i,3) = tot_errortime;
    List(i,4) = tot_skip_dist;
    List(i,5) = Total;
    List(i,6) = Completed;% store all the information
    %dlmwrite('list.txt',List,'\t');
end
disp('Rank list based on Completed')
j=0;
k=0;
Comp(1,1)=0;
Comp(1,2)=0;
inComp(1,1)=0;
inComp(1,2)=0;%initialse
for i=1:no_of_files % Add all completed ones to Comp variable and all incompleted ones to inComp variable
    if List(i,6) == 1
        k=k+1;
        Comp(k,1)=i;% video file number
        Comp(k,2)=List(i,5);% total score
    else
        j=j+1;
        inComp(j,1)=i;
        inComp(j,2)=List(i,5);
    end
end
[tot,index] = sort(Comp(:,2),'descend');% Sort it in descending ordr
for i = 1:length(index) % display Sorted with appropriate video file number
    disp([Comp(index(i),1) tot(i)])
end
%Similarly do it for Incomplete ones 
disp('Rank list based on incomplete')
[Name,Dist] = sort(inComp(:,2),'descend');
for i = 1:length(Dist)
    disp([inComp(Dist(i),1) Name(i)])
end