S = load('cw1a.mat')

covfunc = {@covProd,{@covPeriodic, @covSEiso}}; %set the Covariance fuction as SE

meanfunc = [];
likfunc = @likGauss;

hyp.cov = [0, 0, 0]; hyp.lik = 1; %initialise hyperparameters
%minimise negative log marginal likelyhood

hyp2.cov = [-0.5, 0, 0, 2, 0]; %initialise hyperparameters

xs = linspace(-5, 5, 200);
K = feval( covfunc, hyp2.cov , xs);% find covariance matrix K
K = K + 1e-6*eye(200); ;% make K positive definite ( stability )
y = chol(K)'* randn( 200 , 1);% jointly generate y from x