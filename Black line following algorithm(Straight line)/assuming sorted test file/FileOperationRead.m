P = dlmread('Practical.txt');
I = dlmread('Ideal.txt');
XP = P(:,1);
XP = XP';
YP = P(:,2);
YP = YP';
dirP = P(:,3);
dirP = dirP';
XI = I(:,1);
XI = XI';
YI = I(:,2);
YI = YI';
dirI = I(:,3);
dirI = dirI';
PLen = length(P);
ILen = length(I);

%Event Detection
Eflag = 1;
Ei = 1;
E = [];
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
NofEvents = length(E(:,1))
E

%Finding Initial Point
left = E(1,3);
right = E(2,3);
num = ceil(YP(1));
index = Search(left,right,num,YI)
if index == -1
    print = 'Wrong initial position, not in the path'
    return
end

%comparision Algorithm
if (dirP(index) == 1) || (dirP(index) == 3)
    Xmax = XI(index)+0.5;
    Xmin = XI(index)-0.5;
    Ymax = YI(index)+10;
    Ymin = YI(index)-10;
end
if (dirP(index) == 2) || (dirP(index) == 4)
    Xmax = XI(index)+10;
    Xmin = XI(index)-10;
    Ymax = YI(index)+0.5;
    Ymin = YI(index)-0.5;
end
ECount = 1;
Errorcount = 0;
Error = [];
Errorflag = 0;
for i=1:PLen
    if (XP(i) <= Xmax) && (XP(i) >= Xmin) && (YP(i) <= Ymax) && (YP(i) >= Ymin)
        if Errorflag == 1
            Errorflag = 0;
            Error(Errorcount,4) = XP(i-1);
            Error(Errorcount,5) = YP(i-1);
            Error(Errorcount,6) = 0;%ZP(i-1);
        end
        if YP(i) >= ((3*(Ymax-Ymin)/4)+Ymin) && ((dirP(i) == 1) || (dirP(i) == 3))
            left = 1;
            right = ILen;
            num = YP(i);
            Uindex=Search(left,right,num,YI);
            if Uindex ~= -1
                Xmax = XI(Uindex)+0.5;
                Xmin = XI(Uindex)-0.5;
                Ymax = YI(Uindex)+10;
                Ymin = YI(Uindex)-10;
            end
        end
        if (XP(i) >= ((3*(Xmax-Xmin)/4)+Xmin)) && ((dirP(i) == 2) || (dirP(i) == 4))
            left = 1;
            right = ILen;
            num = XP(i);
            Uindex=Search(left,right,num,XI);
            if Uindex ~= -1
                Xmax = XI(Uindex)+10;
                Xmin = XI(Uindex)-10;
                Ymax = YI(Uindex)+0.5;
                Ymin = YI(Uindex)-0.5;
            end
        end
    else
        left = 1;
        right = ILen;
        num = XP(i);
        Xindex=Search(left,right,num,XI);
        left = 1;
        right = ILen;
        num = YP(i);
        Yindex=Search(left,right,num,YI);
        if (Xindex == -1) || (Yindex == -1)
            if Errorflag == 0
                Errorcount = Errorcount + 1;
                Error(Errorcount,1) = XP(i-1);
                Error(Errorcount,2) = YP(i-1);
                Error(Errorcount,3) = 0;%ZP(i-1);
                Errorflag = 1;
            end
        else
            if (dirP(i) == 1) || (dirP(i) == 3)
                Xmax = XI(Xindex)+0.5;
                Xmin = XI(Xindex)-0.5;
                Ymax = YI(Yindex)+10;
                Ymin = YI(Yindex)-10;
            end
            if (dirP(i) == 2) || (dirP(i) == 4)
                Xmax = XI(Xindex)+10;
                Xmin = XI(Xindex)-10;
                Ymax = YI(Yindex)+0.5;
                Ymin = YI(Yindex)-0.5;
            end
            %Error(Errorcount,4) = XP(i-1);
            %Error(Errorcount,5) = YP(i-1);
            %Error(Errorcount,6) = ZP(i-1);
        end
    end 
end 
Error
        