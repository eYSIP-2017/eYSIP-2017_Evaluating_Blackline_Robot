clear;
clc;
List(1,1) = 0;
no_of_files = input('Total Number of videos to compute - ');
width = input(' Enter the width of the line (in cm) - ');
for i = 1:no_of_files
    disp('.')
    disp('.')
    pVideo = strcat('Comparing Video ',num2str(i));
    disp(pVideo)
    filename = strcat(num2str(i),'.txt');
    P = dlmread(filename);
    out = Compare(P,width);
    tot_dist = out(1);
    tot_errortime = out(2);
    %List = dlmread('list.txt');
    %list_len = length(List);
    List(i,1) = i;
    List(i,2) = tot_dist;
    List(i,3) = tot_errortime;
    %dlmwrite('list.txt',List,'\t');
end
disp('Rank list based on minimum error')
[Name,Dist] = sort(List(:,2));
disp([Name Dist])
%disp('Fastest bot is')
%disp(min_time_i)
%disp('and time taken is')
%disp(min_time)
