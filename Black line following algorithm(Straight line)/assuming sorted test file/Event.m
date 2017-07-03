function out = Event(x,y,A)
for i=1:length(A(:,1))
    if (x <= A(i+1,1)) && (x >= A(i,1)) && (y <= A(i+1,2)) && (y >= A(i,2))
        out = i;
    end
end