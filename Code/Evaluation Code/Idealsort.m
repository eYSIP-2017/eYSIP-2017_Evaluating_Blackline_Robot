function out = Idealsort()
I = dlmread('Ideal_file.txt');% Read the Ideal Sampled text file
XI = I(:,1);
XI = (XI(:)-1).*0.03527;% Convert it in cms as the pic size was 5000x5000 the centimeter/pixel is 0.03527
YI = I(:,2);
YI = 5000-YI;% Shift the Yaxis to Bottom Left from the Top Left
YI = (YI(:)-155).*0.03527;% Convert it in cms as the pic size was 5000x5000 the centimeter/pixel is 0.03527
PNI = I(:,3);% Previous Node
PNI = PNI';
NNI = I(:,4);% Next Node
NNI = NNI';
WBI = I(:,5);% Weight of the branch between Previous Node and Next Node
WBI = WBI';
XI = XI';
YI = YI';
disp('.')
ILen = length(I);
Ideal(50,50,1,1)=0;
Ideal(50,50,1,2)=0;
% Loop to Sort the ideal file according to different nodes as a 4-D Matrix
% Ideal(PreviousNode,NextNode,X-cordinate,Ycordinate,Weightofnode)
for i=1:ILen
    if (Ideal(PNI(i),NNI(i),1,1) == 0) % if the Pnode and Nnode occurs for the first time then overwrite Zeroes and store X,Y,W
        Ideal(PNI(i),NNI(i),1,1) = XI(i);
        Ideal(PNI(i),NNI(i),1,2) = YI(i);
        Ideal(PNI(i),NNI(i),1,3) = WBI(i);
    else % if the Pnode and Nnode has already occured then find how many are added(by length function) add this one at the end
        Ideal(PNI(i),NNI(i),length(Ideal(PNI(i),NNI(i),:,1))+1,1) = XI(i);
        Ideal(PNI(i),NNI(i),length(Ideal(PNI(i),NNI(i),:,2))+1,2) = YI(i);
        Ideal(PNI(i),NNI(i),length(Ideal(PNI(i),NNI(i),:,2))+1,3) = WBI(i);
    end
end
out = Ideal;
end