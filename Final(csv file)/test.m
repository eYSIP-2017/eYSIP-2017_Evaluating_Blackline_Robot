%clear;
%clc;
I = dlmread('ideal_test_1.txt');
ILen = length(I);
k=1;
for i=1:20:ILen
XI(k) = I(i,1);
XI(k) = (XI(k)-1).*0.03527;
YI(k) = I(i,2);
YI(k) = 5000-YI(k);
YI(k) = (YI(k)-145).*0.03527;
%AI = idealfile(XI,YI);
%XI = AI(:,1);
%YI = AI(:,2);
PNI(k) = I(i,3);
NNI(k) = I(i,4);
WBI(k) = I(i,5); 
k=k+1;
%DI(:)=0;
%TI(:)=0;
end
XI = XI';
ILen = length(XI);
YI = YI';
PNI = PNI';
NNI = NNI';
WBI = WBI';
%dlmwrite('ideal_test.txt',[XI YI PNI NNI WBI],'\t');