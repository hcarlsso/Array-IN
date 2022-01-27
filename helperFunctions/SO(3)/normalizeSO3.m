function Rnorm = normalizeSO3(R)

[u,s,v] = svd(R);

Rnorm = u*v';
end