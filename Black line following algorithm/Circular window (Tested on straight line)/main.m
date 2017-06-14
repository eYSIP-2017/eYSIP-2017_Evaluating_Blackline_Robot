clear;
clc;
%declaration of global variables
P = dlmread('Practical_test.txt');
I = dlmread('Ideal_test.txt');
XP = P(:,1);
XP = XP';
YP = P(:,2);
YP = YP';
dirP = P(:,3);
dirP = dirP';
TP = P(:,4);
TP = TP';
XI = I(:,1);
XI = XI';
YI = I(:,2);
YI = YI';
dirI = I(:,3);
dirI = dirI';
PLen = length(P);
ILen = length(I);
radius = 1;

%Event Detection
Ei = 1;
E(1,1) = 0;
Eflag = 1;
for i=2:ILen
    if (I(i,1) == I(i-1,1)) && (I(i,2) ~= I(i-1,2))
        if Eflag == 1
            E(Ei,1) = I(i-1,1);
            E(Ei,2) = I(i-1,2);
            E(Ei,3) = i-1;
            Ei = Ei + 1;
            Eflag = 0;
        elseif (Eflag == 0) && ((E(Ei-1,2) ~= I(i,2)) && (E(Ei-1,1) ~= I(i,1)))
            Eflag = 1;
        end   
    elseif (I(i,1) ~= I(i-1,1)) && (I(i,2) == I(i-1,2))
        if Eflag == 1
            E(Ei,1) = I(i-1,1);
            E(Ei,2) = I(i-1,2);
            E(Ei,3) = i-1;
            Ei = Ei + 1;
            Eflag = 0;
        elseif (Eflag == 0) && ((E(Ei-1,2) ~= I(i,2)) && (E(Ei-1,1) ~= I(i,1)))
            Eflag = 1;
        end    
    end
end

NofEvents = length(E(:,1));
E(Ei,1) = I(i,1);
E(Ei,2) = I(i,2);
E(Ei,3) = i;
disp('Number of events')
disp(NofEvents)
disp('Events')
disp(E)

%Finding Initial Point
left = E(1,3);
right = E(2,3);
numx = (XP(1));
numy = (YP(1));
initindex = CircleSearch(left,right,numx,XI,numy,YI);
if initindex == -1
    print = 'Wrong initial position, not in the path';
    disp(print)
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
ECount = 1;
Errorcount = 0;
Error(1,1) = 0;
Errorflag = 0;
for i=1:PLen
    if (CircleWindow(Xmax,Xmin,Ymax,Ymin,XP(i),Xmax-radius,YP(i),Ymax-radius))
        if Errorflag == 1
            Errorflag = 0;
            Error(Errorcount,4) = XP(i);
            Error(Errorcount,5) = YP(i);
            Error(Errorcount,6) = TP(i);
        end
        if ((YP(i) >= ((3*(Ymax-Ymin)/4)+Ymin)) || (YP(i) <= ((Ymax-Ymin)/4)+Ymin))
            left = 1;
            right = ILen;
            numx = (XP(i));
            numy = (YP(i));
            Uindex = CircleSearch(left,right,numx,XI,numy,YI);
            if Uindex ~= -1
                Xmax = XI(Uindex)+radius;
                Xmin = XI(Uindex)-radius;
                Ymax = YI(Uindex)+radius;
                Ymin = YI(Uindex)-radius;
            end
        end
        if ((XP(i) >= ((3*(Xmax-Xmin)/4)+Xmin)) || (XP(i) <= (((Xmax-Xmin)/4)+Xmin)))
            left = 1;
            right = ILen;
            numx = (XP(i));
            numy = (YP(i));
            Uindex = CircleSearch(left,right,numx,XI,numy,YI);
            if Uindex ~= -1
                Xmax = XI(Uindex)+radius;
                Xmin = XI(Uindex)-radius;
                Ymax = YI(Uindex)+radius;
                Ymin = YI(Uindex)-radius;
            end
        end
    else
        left = 1;
        right = ILen;
        numx = XP(i);
        numy = YP(i);
        Uindex = CircleSearch(left,right,numx,XI,numy,YI);
        if (Uindex == -1)
            if Errorflag == 0
                Errorcount = Errorcount + 1;
                Error(Errorcount,1) = XP(i-1);
                Error(Errorcount,2) = YP(i-1);
                Error(Errorcount,3) = TP(i-1);
                Errorflag = 1;
            end
        else
            Xmax = XI(Uindex)+radius;
            Xmin = XI(Uindex)-radius;
            Ymax = YI(Uindex)+radius;
            Ymin = YI(Uindex)-radius;
        end
    end 
end

if(Error(1,1) == 0)
    disp('A perfect run')
else
    disp('Error is')
    disp('it has X and Y co-ordinate with time when left and X and Y co-ordinate with time when it came back to the line')
    disp(Error)
end

        