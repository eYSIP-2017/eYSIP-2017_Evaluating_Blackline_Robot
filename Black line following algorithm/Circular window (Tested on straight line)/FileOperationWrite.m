clear;
clc;

x = 20;
y = 30;

for i=1:50
    A(i,1)=x;
    A(i,2)=y;
    A(i,3)=90;
    A(i,4)=i;
    y=y+1;
end
for i=51:100
    A(i,1)=x;
    A(i,2)=y;
    A(i,3)=0;
    A(i,4)=i;
    x=x+1;
end
for i=101:150
    A(i,1)=x;
    A(i,2)=y;
    A(i,3)=90;
    A(i,4)=i;
    y=y+1;
end
for i=151:200
    A(i,1)=x;
    A(i,2)=y;
    A(i,3)=270;
    A(i,4)=i;
    y=y-1;
end
for i=201:250
    A(i,1)=x;
    A(i,2)=y;
    A(i,3)=180;
    A(i,4)=i;
    x=x-1;
end
for i=251:300
    A(i,1)=x;
    A(i,2)=y;
    A(i,3)=90;
    A(i,4)=i;
    y=y+1;
end
for i=301:320
    A(i,1)=x;
    A(i,2)=y;
    A(i,3)=180;
    A(i,4)=i;
    x=x-1;
end
dlmwrite('Ideal.txt',A,'\t');
x = 20;
y = 30;

for i=1:50
    B(i,1)=x;
    B(i,2)=y;
    B(i,3)=90;
    B(i,4)=i;
    y=y+1;
end
for i=51:60
    B(i,1)=0;
    B(i,2)=0;
    B(i,3)=0;
    B(i,4)=i;
    x=x+1;
end
for i=61:100
    B(i,1)=x;
    B(i,2)=y;
    B(i,3)=0;
    B(i,4)=i;
    x=x+1;
end
for i=101:150
    B(i,1)=x;
    B(i,2)=y;
    B(i,3)=90;
    B(i,4)=i;
    y=y+1;
end
for i=151:160
    B(i,1)=0;
    B(i,2)=0;
    B(i,3)=0;
    B(i,4)=i;
    y=y-1;
end
for i=161:200
    B(i,1)=x;
    B(i,2)=y;
    B(i,3)=270;
    B(i,4)=i;
    y=y-1;
end
for i=201:250
    B(i,1)=x;
    B(i,2)=y;
    B(i,3)=180;
    B(i,4)=i;
    x=x-1;
end
for i=251:300
    B(i,1)=x;
    B(i,2)=y;
    B(i,3)=90;
    B(i,4)=i;
    y=y+1;
end
for i=301:320
    B(i,1)=x;
    B(i,2)=y;
    B(i,3)=180;
    B(i,4)=i;
    x=x-1;
end
dlmwrite('Practical.txt',B,'\t');