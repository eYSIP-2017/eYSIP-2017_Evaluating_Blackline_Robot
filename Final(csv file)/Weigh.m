function out = Weigh(Ideal)
Weight(50,50)=0;
for i = 1:50
    for j = 1:50
        for k = 1:length(Ideal(i,j,:,1))
        if Ideal(i,j,k,1) > 1            
            if (i == 2) && (j == 3)
                Weight(i,j) = Weight(i,j)+0.5;
                Weight(j,i) = Weight(j,i)+0.5;
            else
                Weight(i,j) = Weight(i,j)+1;
                Weight(j,i) = Weight(j,i)+1;
            end
        end
        end
    end
end
out = Weight;
end