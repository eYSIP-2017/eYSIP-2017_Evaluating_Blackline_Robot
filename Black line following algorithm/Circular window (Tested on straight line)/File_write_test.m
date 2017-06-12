clear;
clc;
x=10;
d=0;
for i=1:(70*x)
    A(i,1)=75;
    A(i,2)=70+d;
    d=d+0.1;
    A(i,3)=90;
end
dlmwrite('Ideal_test.txt',A,'\t');