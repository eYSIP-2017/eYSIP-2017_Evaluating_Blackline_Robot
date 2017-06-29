function out = Compare(P,width,Ideal,Weight)
%declaration of global variables
%P = dlmread('Practical_test.txt');

XP = P(:,3);
XP = XP';
YP = P(:,4);
YP = YP';
%dirP = P(:,3);
%dirP = dirP';
TP = P(:,5);
TP = TP';
I = dlmread('Ideal_test.txt');
XI = I(:,1);
%XI = (XI(:)-1).*0.03527;
YI = I(:,2);
%YI = 5000-YI;
%YI = (YI(:)-145).*0.03527;
%AI = idealfile(XI,YI);
%XI = AI(:,1);
%YI = AI(:,2);
PNI = I(:,3);
PNI = PNI';
NNI = I(:,4);
NNI = NNI';
WBI = I(:,5);
WBI = WBI';
%Weight(50,50)=0;
%dirI = I(:,3);
%dirI = dirI';
%dlmwrite('test.txt',[XI YI],'\t');
XI = XI';
YI = YI';
disp('.')
PLen = length(XP);
ILen = length(XI);
%width = input(' Enter the width of the line (in cm) - ');
radius = width/2;
%{
Ideal(50,50,1,1)=0;
Ideal(50,50,1,2)=0;
for i=1:ILen
    %disp(i)
    if (Ideal(PNI(i),NNI(i),1,1) == 0)
        Ideal(PNI(i),NNI(i),1,1) = XI(i);
        Ideal(PNI(i),NNI(i),1,2) = YI(i);
        Ideal(PNI(i),NNI(i),1,3) = WBI(i);
    else
        Ideal(PNI(i),NNI(i),length(Ideal(PNI(i),NNI(i),:,1))+1,1) = XI(i);
        Ideal(PNI(i),NNI(i),length(Ideal(PNI(i),NNI(i),:,2))+1,2) = YI(i);
        Ideal(PNI(i),NNI(i),length(Ideal(PNI(i),NNI(i),:,2))+1,3) = WBI(i);
    end
end
%}
disp('.')
%{
for i = 1:50
    for j = 1:50
        for k = 1:length(Ideal(i,j,:,1))
        if Ideal(i,j,k,1) > 1            
            if (i == 2) && (j == 3)
                Weight(i,j) = Weight(i,j)+0.5;
                Weight(j,i) = Weight(j,i)+0.5;
            else
                Weight(i,j) = Weight(i,j)+1;
                Weight(j,i) = Weight(j,i)+1;
            end
        end
        end
    end
end
%}
disp('.')
%Finding Initial Point
left = 1;
right = ILen;
numx = (XP(1));
numy = (YP(1));
initindex = CircleSearch(left,right,numx,XI,numy,YI,radius);
if initindex == -1
    print = 'Wrong initial position, not in the path';
    disp(print)
    out = [100000,0,0,0];
    return
end
print = ['initial position is X = ',num2str(XI(initindex)),', Y = ',num2str(YI(initindex)),', Starting index = ',num2str(initindex)];
disp(print)
disp('Result')

%comparision Algorithm

Xmax = XI(initindex)+radius;
Xmin = XI(initindex)-radius;
Ymax = YI(initindex)+radius;
Ymin = YI(initindex)-radius;
%ECount = 1;
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
    %disp(i)
    if (CircleWindow(Xmax,Xmin,Ymax,Ymin,XP(i),Xmax-radius,YP(i),Ymax-radius,radius))
        if Errorflag == 1
            Errorflag = 0;
            Error(Errorcount,6) = XP(i);
            Error(Errorcount,7) = YP(i);
            Error(Errorcount,8) = TP(i);
            left = 1;
            right = ILen;
            numx = XP(i);
            numy = YP(i);
            Uindex = CircleSearch(left,right,numx,XI,numy,YI,radius);
            Error(Errorcount,9) = PNI(Uindex);
            Error(Errorcount,10) = NNI(Uindex);
            if (PrevNode == PNI(Uindex)) && (NextNode == NNI(Uindex)) %&& (Branch == WBI(Uindex))
                for k=Errorindex:Uindex
                      SkipDist = SkipDist + (1./28.346);
                end
                Error(Errorcount,11) = SkipDist-SkipBuff;
                Error(Errorcount,13) = Uindex;
                SkipBuff = SkipDist;
            else
                for l=1:length(Ideal(PNI(Uindex),NNI(Uindex),:,1))
                    if (Ideal(PNI(Uindex),NNI(Uindex),l,1) == XI(Uindex)) && (Ideal(PNI(Uindex),NNI(Uindex),l,2) == YI(Uindex))
                        sdist = l;
                        SkipDist = SkipDist + sdist .* (1./28.346);
                    end
                end
                for l=1:length(Ideal(PrevNode,NextNode,:,1))
                    if (Ideal(PNI(Uindex),NNI(Uindex),l,1) == XI(Uindex)) && (Ideal(PNI(Uindex),NNI(Uindex),l,2) == YI(Uindex))
                        sdist = length(Ideal(PrevNode,NextNode,:,1))-l;
                        SkipDist = SkipDist + sdist .* (1./28.346);
                    end
                end
                    [sdist(1),route1] = dijkstra(Weight,PrevNode,PNI(Uindex));
                    [sdist(2),route2] = dijkstra(Weight,PrevNode,NNI(Uindex));                    
                    [sdist(3),route1] = dijkstra(Weight,NextNode,PNI(Uindex));
                    [sdist(4),route2] = dijkstra(Weight,NextNode,NNI(Uindex));
                     sdist = min(sdist);
                     if sdist > 19963
                         sdist = 0;
                     end
                     PrevNode = PNI(Uindex);
                     NextNode = NNI(Uindex);
                SkipDist = SkipDist + sdist .* (1./28.346); 
                Error(Errorcount,11) = SkipDist-SkipBuff;
                Error(Errorcount,13) = Uindex;
                SkipBuff = SkipDist;
            end
        end
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
        Errorindex = Uindex;
    else
        left = 1;
        right = ILen;
        numx = XP(i);
        numy = YP(i);
        Uindex = CircleSearch(left,right,numx,XI,numy,YI,radius);
        if (Uindex == -1)
            if Errorflag == 0
                Errorcount = Errorcount + 1;
                Error(Errorcount,1) = XP(i-1);
                Error(Errorcount,2) = YP(i-1);
                Error(Errorcount,3) = TP(i-1);
                Error(Errorcount,4) = PNI(Errorindex);
                Error(Errorcount,5) = NNI(Errorindex);
                Error(Errorcount,12) = Errorindex;
                Errorflag = 1;
            end
            temp_dist = SmallestDistance(XP(i),YP(i),XI,YI);
            if temp_dist > 1
                temp_dist = temp_dist - 1;
            end
            tot_dist = tot_dist + temp_dist(1);
        else
            Xmax = XI(Uindex)+radius;
            Xmin = XI(Uindex)-radius;
            Ymax = YI(Uindex)+radius;
            Ymin = YI(Uindex)-radius;
            if (Errorflag == 0) && (PrevNode ~= PNI(Uindex)) && (NextNode ~= NNI(Uindex))
                PrevNode = PNI(Uindex);
                NextNode = NNI(Uindex);
            end
        end
    end 
end
for i=1:PLen
            left = 1920;
            right = ILen;
            numx = XP(i);
            numy = YP(i);
            Uindex = CircleSearch(left,right,numx,XI,numy,YI,radius);
            if Uindex > 0
                Completed = 1;
            end
end
%{
tot_errortime = 0;
for i=1:(Errorcount-1)
    tot_errortime = tot_errortime + (Error(i,8)-Error(i,3));
end
%}
tot_errortime = TP(Plen);
if(Error(1,1) == 0)
    disp('A perfect run')
else
    disp('Total Error Distance is')
    disp(tot_dist)
    disp('Total Error time is')
    disp(tot_errortime)
    disp('Error is')
    disp('it has X and Y co-ordinate with time when left and X and Y co-ordinate with time when it came back to the line')
    disp(Error)
end
out = [tot_dist,tot_errortime,SkipDist,Completed];
disp(out)
end
