function Phiw = PhiSO3(w)
% Left-Jacobian to SO(3)
% sum_k 1/(k + 1)! ad(w)^k
normw = norm(w);

% if(normw > pi/2)
%     error('formula not sure')
% end
if(normw > 0)
    adw = adjSO3(w);
    
    Phiw = eye(3) + (1/(2*normw^2))*(4-normw*sin(normw)-4*cos(normw))*adw+...
        (1/(2*normw^3))*(4*normw-5*sin(normw)+normw*cos(normw))*adw^2+...
        (1/(2*normw^4))*(2-normw*sin(normw)-2*cos(normw))*adw^3+...
        (1/(2*normw^5))*(2*normw-3*sin(normw)+normw*cos(normw))*adw^4;
else
    Phiw = eye(3);
end
end
