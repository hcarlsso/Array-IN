function R = expSO3(w)

normw = norm(w);

if(normw == 0)
    R = eye(3);
    return;
end
w_hat = HatSO3(w);

R = eye(3) + sin(normw)*w_hat/normw + (1-cos(normw))*w_hat*w_hat/(normw^2);

