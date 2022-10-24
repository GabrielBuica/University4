S = load('cw1a.mat')

hyp = struct('mean', [], 'cov', [0 0], 'lik', -1);

covfunc = @covPeriodic; %set the Covariance fuction as SE

meanfunc = [];
likfunc = @likGauss;

hyp.cov = [0, 0, 0]; hyp.lik = 1; %initialise hyperparameters
%minimise negative log marginal likelyhood
hyp2 = minimize(hyp, @gp, -100, @infGaussLik, meanfunc, covfunc, likfunc, x, y);

hyp2
exp(hyp2.cov)
exp(hyp2.lik)

%set targets
xs = linspace(-3, 3, 100)'; 
%train GP
[mu s2] = gp(hyp2, @infGaussLik, meanfunc, covfunc, likfunc, x, y, xs);

f = [mu+2*sqrt(s2); flipdim(mu-2*sqrt(s2),1)];
  fill([xs; flipdim(xs,1)], f, [7 7 7]/8)
  hold on; plot(xs, mu); plot(x, y, '+')