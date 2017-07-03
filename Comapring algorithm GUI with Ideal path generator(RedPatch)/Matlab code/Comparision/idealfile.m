function out = idealfile(X,Y)
x=X(1);
y=Y(1);
j=1;
for i=2:length(X)
    if ((X(i)-x(j))>0.1) && (X(i)>X(i-1))
        while x(j)<X(i)
            j = j+1;
            x(j) = x(j-1)+0.1;
            y(j) = y(j-1);
        end
    elseif ((x(j)-X(i))>0.1) && (X(i)<X(i-1))
        while x(j)>X(i)
            j = j+1;
            x(j) = x(j-1)-0.1;
            y(j) = y(j-1);
        end
    end
    if ((Y(i)-y(j))>0.1) && (Y(i)>Y(i-1))
        while y(j)<Y(i)
            j = j+1;
            x(j) = x(j-1);
            y(j) = y(j-1)+0.1;
        end
    elseif ((y(j)-Y(i))>0.1) && (Y(i)<Y(i-1))
        while y(j)>Y(i)
            j = j+1;
            x(j) = x(j-1);
            y(j) = y(j-1)-0.1;
        end
    end
end
out = [x' y'];
end