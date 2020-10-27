%% Written by Seyedeh-Zahra Mousavi
%  -angle: An n*n matrix that is contains the angle from the middle element ( (n+1)/2 , (n+1)/2 ). 
%  -n is odd.
%%
function [angle ] =compute_angle_matrix( n  )

angle=zeros(n,n);
mid=ceil(n/2);
x0=mid;
y0=-mid;
for i=1:n
    for j=1:n
        if ~(i==mid && j==mid)
            x1=j;
            y1=-i;
            m=(y1-y0)/(x1-x0);
            a=atan(m);
            if a<0
                a=a+pi;
            end
            angle(i,j)=a;
            
            
        end
    end
end

end

