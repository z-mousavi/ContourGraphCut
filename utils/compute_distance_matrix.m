%% Written by Seyedeh-Zahra Mousavi
%  -distance: An n*n matrix that is contains the distance from the middle element ( (n+1)/2 , (n+1)/2 ). 
%  -n is odd.
%%
function [ distance ] = compute_distance_matrix( n )
distance=zeros(n,n);
mid=ceil(n/2);
for i=1:n
    for j=1:n
        distance(i,j)=max(abs(i-mid),abs(j-mid));
         
    end
end

end

