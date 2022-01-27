function [out] = myfminunc(objfun, x0, options)

[x_opt,fval,exitflag,output,grad,hessian] = fminunc(objfun,x0,options);

out = struct;
out.x_opt = x_opt;
out.fval = fval;
out.exitflag = exitflag;
out.output = output;
out.grad = grad;
out.hessian = hessian;



end