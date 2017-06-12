function out = Search(left,right,numx,X,numy,Y)
flag = 0;
for i=left:right
    Xmax = X(i)+1;
    Xmin = X(i)-1;
    Ymax = Y(i)+0.1;
    Ymin = Y(i)-0.1;
    if ((Xmax >= numx) && (Xmin <= numx)) && ((Ymax >= numy) && (Ymin <= numy))
        index = i;
        flag = 1;
    end
end
if flag == 0
    index = -1;
end
out = index;