function out = CircleWindow(Ymax,Ymin,numx,X,numy,Y)
flag = 0;

for j=0:10
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
out = flag;