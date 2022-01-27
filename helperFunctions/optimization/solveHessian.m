function hf =solveHessian(test_function, a)
% Objective: Generates Hessian of a function at some point
%-----------------------------------------------------------------------
% f=solveHessian(a,test_function)
% where a=input vector
%       test_function=objective function
%-----------------------------------------------------------------------
% Output: f= Hesian matrix
%-----------------------------------------------------------------------

% Code by:
% Salil Sharma
% May 3, 2017
%-----------------------------------------------------------------------

l=length(a); %Hessian would be lxl matrix
ep=0.0001; % step size for numerical diffrentiation
valf=test_function(a); % value of obj function at a
ep2=ep*ep;
ep3=4*ep*ep;
hf = zeros(l,l);
for i=1:length(a)
    x1=a;
    x1(i)=a(i)-ep; %Change ith element in x1
    x2=a;
    x2(i)=a(i)+ep; %Change ith element in x2
    hf(i,i)=(test_function(x2)-2*valf+test_function(x1))/ep2; % diagonal entries
    j=i+1;
    while j<=length(a) % Loop computes the rest of the elements of the Hessian matrix
        x1(j)=a(j)-ep; % Lower the value of step size
        x2(j)=a(j)+ep; % Increment the value of step size
        v4=test_function(x1); % compute the respective values
        v1=test_function(x2); % compute the respective values
        x1(j)=x1(j)+2*ep; 
        x2(j)=x2(j)-2*ep;
        v2=test_function(x1);
        v3=test_function(x2);
        hf(i,j)=(v1+v4-v2-v3)/ep3;
        hf(j,i)=hf(i,j); % d2f/dxdy is same as that of d2f/dydx
        x1(j)=a(j);
        x2(j)=a(j); 
        j=j+1;
    end
end

% for i=1:length(a)    
%     while j<=length(a) % Loop computes the rest of the elements of the Hessian matrix
%         hf(j,i)=hf(i,j); % d2f/dxdy is same as that of d2f/dydx
%     end
% end
end
