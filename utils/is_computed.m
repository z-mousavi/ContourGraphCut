function [ flag,f ] = is_computed( x )
flag=0;
f=0;
global c;
global xs;
global fs;
for i=1:c
    x1=xs(:,i);
    s=norm(abs(x1-x));
    if s<=eps
        flag=1;
        f=fs(i);
        
    end
end


end

