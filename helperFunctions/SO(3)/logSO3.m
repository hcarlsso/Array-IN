function [w,errorflag] = logSO3(R)

phy = acos((trace(R)-1)/2);
if(abs(phy)> pi)
    error('angle sup�rieur � pi');
end



if(phy == 0)
    w = zeros(3,1);
elseif (abs(phy) == pi)
    
    A = (R-eye(3))/2;
    w1 = sqrt(-((A(2,2) + A(3,3) - A(1,1))/2));
    
    
    w2 = sqrt(-((A(1,1) + A(3,3) - A(2,2))/2));
    w3 = sqrt(-((A(1,1) + A(2,2) - A(3,3))/2));
    
    if(w1~=0)
        
        if(A(1,2) < 0)
            w2 = -w2;
        end
        if(A(1,3) < 0)
            w3 = -w3;
        end
        
    elseif(w2~=0)
        
        if(A(2,3) < 0)
            w3 = -w3;
        end
    end
    
    w = [w1;w2;w3]*phy;
    
else
    w_hat = (R-R.')/(2*sin(phy))*phy;%on remultiplie par phy pour retrouver le vecteur avec sa norme originale
    w = VecSO3(w_hat);
end

errorflag = 0;
end