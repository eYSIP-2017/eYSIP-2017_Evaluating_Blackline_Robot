clear;
clc;
List(1,1) = 0;
no_of_files = input('Total Number of videos to compute - ');
width = input(' Enter the width of the line (in cm) - ');
Ideal = Idealsort();
Weight = Weigh(Ideal);
for i = 1:no_of_files
    disp('.')
    disp('.')
    pVideo = strcat('Comparing Video ',num2str(i));
    disp(pVideo)
    %filename = strcat(num2str(i),'.txt');
    %P = dlmread(filename);
    filename = strcat(num2str(i),'.csv');
    P = csvread(filename);
    out = Compare(P,width,Ideal,Weight);
    tot_dist = out(1);
    tot_errortime = out(2);
    tot_skip_dist = out(3);
    Completed = out(4);
    Total = tot_dist + 100.*tot_errortime + 10.*tot_skip_dist; 
    %List = dlmread('list.txt');
    %list_len = length(List);
    List(i,1) = i;
    List(i,2) = tot_dist;
    List(i,3) = tot_errortime;
    List(i,4) = tot_skip_dist;
    List(i,5) = Total;
    List(i,6) = Completed;
    %dlmwrite('list.txt',List,'\t');
end
disp('Rank list based on Completed')
j=0;
k=0;
Comp(1,1)=0;
Comp(1,2)=0;
inComp(1,1)=0;
inComp(1,2)=0;
for i=1:no_of_files
    if List(i,6) == 1
        k=k+1;
        Comp(k,1)=i;
        Comp(k,2)=List(i,5);
    else
        j=j+1;
        inComp(j,1)=i;
        inComp(j,2)=List(i,5);
    end
end
[tot,index] = sort(Comp(:,2));
for i = 1:length(Comp)
    disp([Comp(index(i),1) tot(i)])
end
disp('Rank list based on incomplete')
[Name,Dist] = sort(inComp(:,2));
for i = 1:length(inComp)
    disp([inComp(Dist(i),1) Name(i)])
end
%disp('Fastest bot is')
%disp(min_time_i)
%disp('and time taken is')
%disp(min_time)
