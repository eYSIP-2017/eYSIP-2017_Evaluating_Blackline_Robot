for i=1:50
    A(i,1)=150;
    A(i,2)=i;
    A(i,3)=1;
end
for i=51:100
    A(i,1)=100+i;
    A(i,2)=50;
    A(i,3)=2;
end
for i=101:150
    A(i,1)=200;
    A(i,2)=i-50;
    A(i,3)=3;
end
dlmwrite('Ideal.txt',A,'\t');
for i=1:4
    B(i,1)=150;
    B(i,2)=5;
    B(i,3)=1;
end
for i=5:50
    B(i,1)=150;
    B(i,2)=i;
    B(i,3)=1;
end
for i=58:100
    B(i,1)=100+i;
    B(i,2)=50;
    B(i,3)=2;
end
for i=108:150
    B(i,1)=200;
    B(i,2)=i-50;
    B(i,3)=3;
end
dlmwrite('Practical.txt',B,'\t');