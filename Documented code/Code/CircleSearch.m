function out = CircleSearch(left,right,numx,X,numy,Y,radius)
%{
the function searches from left to right if ideal file if numx and numy falls within the Circular Window of a radius 
%}
flag = 0;
for i=left:right
    Xmax = X(i)+radius; %Circle Extremes along X and Y axis
    Xmin = X(i)-radius;
    Ymax = Y(i)+radius;
    Ymin = Y(i)-radius;
    
    for j=0:9 % splits the top and bottom half of the circle into 10 parts
        if j == 0
            k=0;
        else
            k=1;
        end
        %{
            * Knowing Y axis points find the ponts on x axis using Circle Equations
            * (xmax-X(i)).^2 + (Ymax-Y(i)).^2 = radius.^2 is the equation
            * Use Exponential Equation of 2 and scale it to 0-1
            * Exponential is used because the circle for a small change in
              Y axis there is huge change in X axis hence Exponential of 2 is
              used which makes initial points very small and increases at the
              ends which makes the discreet circle more precise.
            * here 0.00098 is used for scaling purpose from 0-1
            * multiplied with radius to scale it up from 0-1 to 0-radius
            * multiplied with k to reduce the error at the extreme points
        %}
        xmax = X(i) + sqrt((radius.^2)-((Ymax-((2.^j).*0.00098.*radius.*k)-Y(i)).^2)); 
        xmin = X(i) - sqrt((radius.^2)-((Ymax-((2.^j).*0.00098.*radius.*k)-Y(i)).^2)); 
        ymax = Ymax-((2.^j).*0.00098.*radius.*k);
        ymin = Ymin+((2.^j).*0.00098.*radius.*k);
        if ((xmax >= numx) && (xmin <= numx)) && ((ymax >= numy) && (ymin <= numy))
            index = i;
            flag = 1;
            break
        end
    end
    for j=0:9 % splits the top and bottom half of the circle into 10 parts
        if j == 0
            k=0;
        else
            k=1;
        end
        %{
            * Knowing X axis points find the ponts on Y axis using Circle Equations
            * (xmax-X(i)).^2 + (Ymax-Y(i)).^2 = radius.^2 is the equation
            * Use Exponential Equation of 2 and scale it to 0-1
            * Exponential is used because the circle for a small change in
              X axis there is huge change in Y axis hence Exponential of 2 is
              used which makes initial points very small and increases at the
              ends which makes the discreet circle more precise.
            * here 0.00098 is used for scaling purpose from 0-1
            * multiplied with radius to scale it up from 0-1 to 0-radius
            * multiplied with k to reduce the error at the extreme points
        %}
        ymax = Y(i) + sqrt((radius.^2)-((Xmax-((2.^j).*0.00098.*radius.*k)-X(i)).^2));
        ymin = Y(i) - sqrt((radius.^2)-((Xmax-((2.^j).*0.00098.*radius.*k)-X(i)).^2));
        xmax = Xmax-((2.^j).*0.00098.*radius.*k);
        xmin = Xmin+((2.^j).*0.00098.*radius.*k);
        if ((xmax >= numx) && (xmin <= numx)) && ((ymax >= numy) && (ymin <= numy))
            index = i;
            flag = 1;
            break
        end
    end
end
if flag == 0 % if the point is not detected at all put index as -1
    index = -1;
end
out = index;
end