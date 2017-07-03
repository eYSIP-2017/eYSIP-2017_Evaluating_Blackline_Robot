function out = Compare(P,width,Ideal,Weight)
%{
It is the main Compare algorithm which checks each X and Y cordinate from
Obtained file with the Ideal File
%}
%declaration of global variables

XP = P(:,3);% Extract X-cordinat from practicle file
XP = XP';
YP = P(:,4);% Extract Y-cordinat from practicle file
YP = YP';
%dirP = P(:,3);% Extract Y-cordinat from practicle file if required in
               % future use
%dirP = dirP';
pc = (1./28.346);
TP = P(:,5);
TP = TP';
I = dlmread('Ideal_File.txt');
XI = I(:,1);% Extract X-cordinat from Ideal file
YI = I(:,2);% Extract X-cordinat from Ideal file
PNI = I(:,3);% Extract Previous Node from Ideal file
PNI = PNI';
NNI = I(:,4);% Extract Next Node from Ideal file
NNI = NNI';
WBI = I(:,5);% Extract Weight of Branch from Ideal file
WBI = WBI';
XI = XI';
YI = YI';
disp('.')
PLen = length(XP);% Length of Practicle File
ILen = length(XI);% Length of Ideal File
radius = width/2; % radius of the Circular window
disp('.')
disp('.')
%Finding Initial Point
left = 1;% Begin Search from
right = ILen;% End the search at
numx = (XP(1));% X-cordinate to be searched
numy = (YP(1));% Y-cordinate to be searched
initindex = CircleSearch(left,right,numx,XI,numy,YI,radius); % Searches the whole Ideal file using a circular window for the initial point and returns at which index
if initindex == -1 % if the initial point is not found then return to the main function
    print = 'Wrong initial position, not in the path';
    disp(print)
    out = [100000,0,0,0];
    return
end
print = ['initial position is X = ',num2str(XI(initindex)),', Y = ',num2str(YI(initindex)),', Starting index = ',num2str(initindex)];
disp(print)
disp('Result')

%comparision Algorithm

%{
                Ymax
                  .
                  . (radius)
                  .
    Xmin. . . . (X,Y) . . . .Xmax
                  .
                  .
                  .
                Ymin

Xmax,Ymax,Xmin,Ymin gives the extreme points of the circle along X and Y
cordinate
%}
Xmax = XI(initindex)+radius;% Extreme points for the initial point
Xmin = XI(initindex)-radius;
Ymax = YI(initindex)+radius;
Ymin = YI(initindex)-radius;
%initialise
Errorcount = 0;
Error(1,1) = 0;
Errorflag = 0;
tot_dist = 0;
Errorindex = 0;
SkipDist = 0;
SkipBuff = 0;
Uindex = initindex;
PrevNode = 1;
NextNode = 2;
%Branch = 1;
Completed = 0;
for i=1:PLen
    if (CircleWindow(Xmax,Xmin,Ymax,Ymin,XP(i),Xmax-radius,YP(i),Ymax-radius,radius))% Checks for XP(i) and YP(i) in the circular window of specified radius 
        if Errorflag == 1
            %if the BOT has come back to the line after going beyond the line
            Errorflag = 0;% change the Flag
            Error(Errorcount,6) = XP(i);% store at which point it has come back with the time stamp
            Error(Errorcount,7) = YP(i);
            Error(Errorcount,8) = TP(i);
            left = 1;
            right = ILen;
            numx = XP(i);
            numy = YP(i);
            Uindex = CircleSearch(left,right,numx,XI,numy,YI,radius); % Searches the whole Ideal file using a circular window for the Specified point and returns at which index
            Error(Errorcount,9) = PNI(Uindex); % store at which nodes it has come back
            Error(Errorcount,10) = NNI(Uindex);
            if (PrevNode == PNI(Uindex)) && (NextNode == NNI(Uindex)) %if the bot has come back to the line within the Same PrevNode and NextNode
                for k=Errorindex:Uindex
                      SkipDist = SkipDist + pc; % Calculates SkipDistance according to no if pixels it has skipped which is Equivalent to the index it has shifted and convert to cms
                end
                Error(Errorcount,11) = SkipDist-SkipBuff; % stores the distance which it has skipped in Error matrix
                Error(Errorcount,13) = Uindex;
                SkipBuff = SkipDist; % skip Buff is updated everytime skipdistance is updated and stored in Error Matrix
            else
                % if the bot has changed the branch
                for l=1:length(Ideal(PNI(Uindex),NNI(Uindex),:,1)) % calculates distance it had to finish on the branch it had left
                    if (Ideal(PNI(Uindex),NNI(Uindex),l,1) == XI(Uindex)) && (Ideal(PNI(Uindex),NNI(Uindex),l,2) == YI(Uindex))
                        sdist = l;
                        SkipDist = SkipDist + sdist .* pc;
                    end
                end
                for l=1:length(Ideal(PrevNode,NextNode,:,1)) % calculates distance it had to Run on the branch it has arrived to reach at that point
                    if (Ideal(PNI(Uindex),NNI(Uindex),l,1) == XI(Uindex)) && (Ideal(PNI(Uindex),NNI(Uindex),l,2) == YI(Uindex))
                        sdist = length(Ideal(PrevNode,NextNode,:,1))-l;
                        SkipDist = SkipDist + sdist .* pc;
                    end
                end
                    [sdist(1),route1] = dijkstra(Weight,PrevNode,PNI(Uindex));% calculate the shortest distances between all node
                    [sdist(2),route2] = dijkstra(Weight,PrevNode,NNI(Uindex));                    
                    [sdist(3),route1] = dijkstra(Weight,NextNode,PNI(Uindex));
                    [sdist(4),route2] = dijkstra(Weight,NextNode,NNI(Uindex));
                     sdist = min(sdist);% take the shortest of the shortest
                     if sdist > 19963 % if it has very huge errors then make it zero
                         sdist = 0;
                     end
                     PrevNode = PNI(Uindex);% Update Prev node and Next node where the bot is presently in
                     NextNode = NNI(Uindex);
                SkipDist = SkipDist + sdist .* pc; % convert pixel to cms
                Error(Errorcount,11) = SkipDist-SkipBuff;%store
                Error(Errorcount,13) = Uindex;
                SkipBuff = SkipDist;%update skipbuffer(which stores the present skipdist) for calculations
            end
        end
        % if bot is following the line and the point is greater than 3/4th 
        % of the circular window then update the circle center to the nearest ideal
        % point.
        % this along Y-axis
        if ((YP(i) >= ((3*(Ymax-Ymin)/4)+Ymin)) || (YP(i) <= ((Ymax-Ymin)/4)+Ymin)) 
            left = 1;
            right = ILen;
            numx = (XP(i));
            numy = (YP(i));
            Uindex = CircleSearch(left,right,numx,XI,numy,YI,radius);
            if Uindex ~= -1
                Xmax = XI(Uindex)+radius;
                Xmin = XI(Uindex)-radius;
                Ymax = YI(Uindex)+radius;
                Ymin = YI(Uindex)-radius;
                PrevNode = PNI(Uindex);
                NextNode = NNI(Uindex);
            end
        end
        % if bot is following the line and the point is greater than 3/4th 
        % of the circular window then update the circle center to the nearest ideal
        % point.
        % this along X-axis
        if ((XP(i) >= ((3*(Xmax-Xmin)/4)+Xmin)) || (XP(i) <= (((Xmax-Xmin)/4)+Xmin)))
            left = 1;
            right = ILen;
            numx = (XP(i));
            numy = (YP(i));
            Uindex = CircleSearch(left,right,numx,XI,numy,YI,radius);
            if Uindex ~= -1
                Xmax = XI(Uindex)+radius;
                Xmin = XI(Uindex)-radius;
                Ymax = YI(Uindex)+radius;
                Ymin = YI(Uindex)-radius;
                PrevNode = PNI(Uindex);
                NextNode = NNI(Uindex);
            end
        end
        Errorindex = Uindex; % updates every time while following the line to have a reference when it goes off the line
    else
        % if the given point is out of the circular window
        left = 1;
        right = ILen;
        numx = XP(i);
        numy = YP(i);
        Uindex = CircleSearch(left,right,numx,XI,numy,YI,radius);% Circle Search the Ideal file if it is present at some other point in the ideal file
        if (Uindex == -1) % if phe point is not found
            if Errorflag == 0 % and if the point was in the Specified window and now it has got off that window
                Errorcount = Errorcount + 1;
                Error(Errorcount,1) = XP(i-1);%store the values where it has got off
                Error(Errorcount,2) = YP(i-1);
                Error(Errorcount,3) = TP(i-1);
                Error(Errorcount,4) = PNI(Errorindex);
                Error(Errorcount,5) = NNI(Errorindex);
                Error(Errorcount,12) = Errorindex;
                Errorflag = 1;
            end
            temp_dist = SmallestDistance(XP(i),YP(i),XI,YI);% calculate the shortest distance by which it is off from the ideal black line
            if temp_dist > 1
                temp_dist = temp_dist - 1;
            end
            tot_dist = tot_dist + temp_dist(1);% add it to the total accumulated error
        else
            %if the point falls in the ideal file(within the window)
            %update the window to that point
            Xmax = XI(Uindex)+radius;
            Xmin = XI(Uindex)-radius;
            Ymax = YI(Uindex)+radius;
            Ymin = YI(Uindex)-radius;
            % if the it is shifted to another branch and not after going
            % off from the line then update the PrevNode and NextNode
            if (Errorflag == 0) && (PrevNode ~= PNI(Uindex)) && (NextNode ~= NNI(Uindex))
                PrevNode = PNI(Uindex);
                NextNode = NNI(Uindex);
            end
        end
    end 
end
%Check if the bot has completed the arena
for i=1:PLen
            left = 1909;% 1909 to the end of ideal file are the indexes it should fall in, to tell that the bot has reached the end.Left variable can be changed
            right = ILen;
            numx = XP(i);
            numy = YP(i);
            Uindex = CircleSearch(left,right,numx,XI,numy,YI,radius);
            if Uindex > 0
                Completed = 1; %if the bot is in the range then declare it as completed 
            end
end
tot_time = TP(PLen); % total time taken is from the time stamp of the video
if(Error(1,1) == 0)
    disp('A perfect run')
else
    disp('Total Error Distance is')
    disp(tot_dist)
    disp('Total time taken is')
    disp(tot_time)
    disp('Error is')
    disp('it has X and Y co-ordinate with time when left and X and Y co-ordinate with time when it came back to the line')
    disp(Error)
end
out = [tot_dist,tot_time,SkipDist,Completed];
disp(out)
end
