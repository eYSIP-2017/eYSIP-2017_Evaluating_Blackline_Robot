function out = CircleSearch(left,right,numx,X,numy,Y)
flag = 0;
small = 100;
for i=left:right
    Xmax = X(i)+1;
    Xmin = X(i)-1;
    Ymax = Y(i)+1;
    Ymin = Y(i)-1;
    for j=0:9
        if j == 0
            k=0;
        else
            k=1;
        end
        xmax = X(i) + sqrt(1-((Ymax-((2.^j).*0.00098.*k)-Y(i)).^2));
        xmin = X(i) - sqrt(1-((Ymax-((2.^j).*0.00098.*k)-Y(i)).^2));
        ymax = Ymax-((2.^j).*0.00098.*k);
        ymin = Ymin+((2.^j).*0.00098.*k);
        if ((xmax >= numx) && (xmin <= numx)) && ((ymax >= numy) && (ymin <= numy))
            if Distance(X(i),Y(i),numx,numy) < small
                small = Distance(X(i),Y(i),numx,numy);
                index = i;
            end
            flag = 1;
        end
    end
    for j=0:9
        if j == 0
            k=0;
        else
            k=1;
        end
        ymax = Y(i) + sqrt(1-((Xmax-((2.^j).*0.00098.*k)-X(i)).^2));
        ymin = Y(i) - sqrt(1-((Xmax-((2.^j).*0.00098.*k)-X(i)).^2));
        xmax = Xmax-((2.^j).*0.00098.*k);
        xmin = Xmin+((2.^j).*0.00098.*k);
        if ((xmax >= numx) && (xmin <= numx)) && ((ymax >= numy) && (ymin <= numy))
            if Distance(X(i),Y(i),numx,numy) < small
                small = Distance(X(i),Y(i),numx,numy);
                index = i;
            end
            flag = 1;
        end
    end
end
if flag == 0
    index = -1;
end
out = index;