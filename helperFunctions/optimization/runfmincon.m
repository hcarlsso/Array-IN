function [out] = runfmincon(objfun, x0, options, varargin)

opt = struct;
if ~isempty(varargin) 
    assert(mod(length(varargin),2) == 0)
    names = varargin{1:2:end};
    values = varargin{2:2:end};
    for k = 1:length(names)
        opt.(names{k}) = values{k};
    end
end
% Set up shared variables with outfun
history.x = [];
history.fval = [];
searchdir = [];
x0 = reshape(x0,[],1);
% Call optimization
% x0 = [-1 1];
% options = optimoptions(@fmincon,'OutputFcn',@outfun,...
%     'Display','iter','Algorithm','active-set');
options.OutputFcn = @outfun;
if isfield(opt,"hessian_and_grad") && opt.("hessian_and_grad")
    printf("Save final hessian and gradient\n")
    [x_opt,fval,exitflag,output,grad,hessian] = fminunc(objfun,x0,options);
else
    [x_opt,fval,exitflag,output] = fminunc(objfun,x0,options);
end
history.x = reshape(history.x, length(x0), []);
out = struct;
out.x_opt = x_opt;
out.fval = fval;
out.exitflag = exitflag;
out.output = output;
if isfield(opt,"hessian_and_grad") && opt.("hessian_and_grad")
    out.grad = grad;
    out.hessian = hessian;
end
out.history = history;
out.searchdir = searchdir;



    function stop = outfun(x,optimValues,state)
        stop = false;
        
        switch state
            case 'init'
                % hold on
            case 'iter'
                % Concatenate current point and objective function
                % value with history. x must be a row vector.
                history.fval = [history.fval; optimValues.fval];
                history.x = [history.x; x];
                % Concatenate current search direction with
                % searchdir.
                searchdir = [searchdir;...
                    optimValues.searchdirection'];
                %  plot(x(1),x(2),'o');
                % Label points with iteration number and add title.
                % Add .15 to x(1) to separate label from plotted 'o'.
                % text(x(1)+.15,x(2),...
                %     num2str(optimValues.iteration));
                % title('Sequence of Points Computed by fmincon');
            case 'done'
                % hold off
            otherwise
        end
    end
end