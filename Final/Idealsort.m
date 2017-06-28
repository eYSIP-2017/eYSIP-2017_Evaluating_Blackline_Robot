function out = Idealsort()
I = dlmread('Ideal_test.txt');
XI = I(:,1);
XI = (XI(:)-1).*0.03527;
YI = I(:,2);
YI = 5000-YI;
YI = (YI(:)-155).*0.03527;
%AI = idealfile(XI,YI);
%XI = AI(:,1);
%YI = AI(:,2);
PNI = I(:,3);
PNI = PNI';
NNI = I(:,4);
NNI = NNI';
WBI = I(:,5);
WBI = WBI';
%dirI = I(:,3);
%dirI = dirI';
%dlmwrite('test.txt',[XI YI],'\t');
XI = XI';
YI = YI';
disp('.')
ILen = length(I);
%width = input(' Enter the width of the line (in cm) - ');
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
out = Ideal;
end