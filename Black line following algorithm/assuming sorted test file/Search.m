function out = Search(left,right,num,A)

flag = 0;
num = ceil(num);

while left <= right
    mid = ceil((left + right) / 2);
    
    if A(mid) == num
        index = mid;
        flag = 1;
        break;
    else if A(mid) > num
            right = mid - 1;
         else
            left = mid + 1;
        end
    end
end
if flag == 0;
    index = -1;
end
out = index;