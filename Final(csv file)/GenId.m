%clear;
%clc;
I = dlmread('ideal_test4.txt');
ILen = length(I);
k=1;
for i=1:ILen
XI(k) = I(i,1);
XI(k) = (XI(k)-1).*0.03527;
YI(k) = I(i,2);
YI(k) = 5000-YI(k);
YI(k) = (YI(k)-145).*0.03527;
%AI = idealfile(XI,YI);
%XI = AI(:,1);
%YI = AI(:,2);
PNI(k) = 0;
NNI(k) = 0;
WBI(k) = 0; 
k=k+1;
%DI(:)=0;
%TI(:)=0;
end
XI = XI';
YI = YI';
PNI = PNI';
NNI = NNI';
WBI = WBI';
dlmwrite('5.txt',[PNI NNI XI YI WBI],'\t');