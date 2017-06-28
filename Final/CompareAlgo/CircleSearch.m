function out = CircleSearch(left,right,numx,X,numy,Y,radius)
flag = 0;
%small = 10000;
for i=left:right
    Xmax = X(i)+radius;
    Xmin = X(i)-radius;
    Ymax = Y(i)+radius;
    Ymin = Y(i)-radius;
    
    for j=0:9
        if j == 0
            k=0;
        else
            k=1;
        end
        xmax = X(i) + sqrt((radius.^2)-((Ymax-((2.^j).*0.00098.*radius.*k)-Y(i)).^2));
        xmin = X(i) - sqrt((radius.^2)-((Ymax-((2.^j).*0.00098.*radius.*k)-Y(i)).^2));
        ymax = Ymax-((2.^j).*0.00098.*radius.*k);
        ymin = Ymin+((2.^j).*0.00098.*radius.*k);
        if ((xmax >= numx) && (xmin <= numx)) && ((ymax >= numy) && (ymin <= numy))
 %           if Distance(X(i),Y(i),numx,numy) < small
  %              small = Distance(X(i),Y(i),numx,numy);
                index = i;
   %         end
            flag = 1;
            break
        end
    end
    for j=0:9
        if j == 0
            k=0;
        else
            k=1;
        end
        ymax = Y(i) + sqrt((radius.^2)-((Xmax-((2.^j).*0.00098.*radius.*k)-X(i)).^2));
        ymin = Y(i) - sqrt((radius.^2)-((Xmax-((2.^j).*0.00098.*radius.*k)-X(i)).^2));
        xmax = Xmax-((2.^j).*0.00098.*radius.*k);
        xmin = Xmin+((2.^j).*0.00098.*radius.*k);
        if ((xmax >= numx) && (xmin <= numx)) && ((ymax >= numy) && (ymin <= numy))
    %        if Distance(X(i),Y(i),numx,numy) < small
     %           small = Distance(X(i),Y(i),numx,numy);
                index = i;
      %      end
            flag = 1;
            break
        end
    end
    %{
    flag = CircleWindow(Xmax,Xmin,Ymax,Ymin,numx,X(i),numy,Y(i),radius);
    if flag == 1
        index = i;
        break
    end
    %}
end
if flag == 0
    index = -1;
end
out = index;
end