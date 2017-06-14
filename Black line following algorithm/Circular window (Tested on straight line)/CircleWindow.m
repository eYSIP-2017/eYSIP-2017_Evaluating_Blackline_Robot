function out = CircleWindow(Xmax,Xmin,Ymax,Ymin,numx,X,numy,Y)
flag = 0;

for j=0:9
    if j == 0
       k=0;
    else
       k=1;
    end
    xmax = X + sqrt(1-((Ymax-((2.^j).*0.00098.*k)-Y).^2));
    xmin = X - sqrt(1-((Ymax-((2.^j).*0.00098.*k)-Y).^2));
    ymax = Ymax-((2.^j).*0.00098.*k);
    ymin = Ymin+((2.^j).*0.00098.*k);
    if ((xmax >= numx) && (xmin <= numx)) && ((ymax >= numy) && (ymin <= numy))
        flag = 1;
    end
end
for j=0:9
    if j == 0
       k=0;
    else
       k=1;
    end
    ymax = Y + sqrt(1-((Xmax-((2.^j).*0.00098.*k)-X).^2));
    ymin = Y - sqrt(1-((Xmax-((2.^j).*0.00098.*k)-X).^2));
    xmax = Xmax-((2.^j).*0.00098.*k);
    xmin = Xmin+((2.^j).*0.00098.*k);
    if ((xmax >= numx) && (xmin <= numx)) && ((ymax >= numy) && (ymin <= numy))
       flag = 1;
    end
end
out = flag;