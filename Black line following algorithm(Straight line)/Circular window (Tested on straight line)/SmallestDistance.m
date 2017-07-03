function out = SmallestDistance(x,y,X,Y)
A = sqrt(((x-X).^2)+((y-Y).^2));
[MIN, Index] = min(A);
out = [MIN, Index];
end