%clear;
%clc;
pc = 0.03527;
I = dlmread('ideal_File_for_2012_Unsampled.txt');
ILen = length(I);
k=1;
for i=1:20:ILen %sample at every 20th point, refer Ideal sort for Pixel to cm conversion
XI(k) = I(i,1);
XI(k) = (XI(k)-1).*pc;
YI(k) = I(i,2);
YI(k) = 5000-YI(k);
YI(k) = (YI(k)-145).*pc;
PNI(k) = I(i,3);
NNI(k) = I(i,4);
WBI(k) = I(i,5); 
k=k+1;
end
XI = XI';
ILen = length(XI);
YI = YI';
PNI = PNI';
NNI = NNI';
WBI = WBI';
dlmwrite('ideal_File.txt',[XI YI PNI NNI WBI],'\t'); %Store it as Ideal_File.txt