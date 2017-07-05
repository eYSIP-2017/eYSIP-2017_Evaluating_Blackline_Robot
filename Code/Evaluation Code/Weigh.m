function out = Weigh(Ideal)
%{
Functio To find Adjacency Matrix
%}
Weight(50,50)=0;
for i = 1:50
    for j = 1:50
        for k = 1:length(Ideal(i,j,:,1))% For all PrevNode and Next Node
        if Ideal(i,j,k,1) > 1   % if the file is not Zero(Because All the Points which doesnot exist in the Ideal file are Zeroes) then increment         
            if (i == 2) && (j == 3)% Because 2,3 node has Multiple Paths hence half the size so add with 0.5
                Weight(i,j) = Weight(i,j)+0.5;
                Weight(j,i) = Weight(j,i)+0.5;
            else %increment the weight
                Weight(i,j) = Weight(i,j)+1;
                Weight(j,i) = Weight(j,i)+1;
            end
        end
        end
    end
end
out = Weight;
end