% %===========================Model 1==================================
clear all
load cw1e.mat

%Mean, covariance and likelihood functions
meanfunc = [];                                  %empty: don't use a mean function
covfunc1 = @covSEard;                           %Model 1
covfunc2 = {@covSum, {@covSEard, @covSEard}};   %Model 2
likfunc = @likGauss;                            %Gaussian likelihood

covfunc = covfunc1;
% Initialise the hyperparameters
hyp = struct('mean', [], 'cov', [0 0 0], 'lik',0);          %Model 1 (D=2)

% Optimized hyperparameters by optimizing the (log) marginal likelihood
hyp2 = minimize(hyp, @gp, -100, @infGaussLik, meanfunc, covfunc, likfunc, x,y);

hyp2
exp(hyp2.cov)
exp(hyp2.lik)

%Closed form for the log marginal-likelihood
K = feval(covfunc, hyp2.cov, x);
data_fit_term = -0.5 * transpose(y) * inv(K + (exp(hyp2.lik)^2)*eye(121,121))*y;
complexity_penalty = 0.5*log(det(K + (exp(hyp2.lik))^2 * eye(121,121)));
constant_term = -(121/2)* log(2*pi);
nlml_check = -(data_fit_term - complexity_penalty + constant_term);

% Compute the (joint) negative log probability (density): nlml
nlml = gp(hyp2, @infGaussLik, meanfunc, covfunc, likfunc, x, y);

% Create new 2-D input test points

x1 = x(:,1);
x2 = linspace(-2.75, 2.75, 11)';
x2 = cat(1,x2,x2,x2,x2,x2,x2,x2,x2,x2,x2,x2);
xs = [x1,x2];

% mu is the prediction output
[mu,s2] = gp(hyp2, @infGaussLik, meanfunc, covfunc, likfunc,x,y, xs);

plusSTD=reshape(mu,11,11)+2*sqrt(reshape(s2,11,11));
negativeSTD=reshape(mu,11,11)-2*sqrt(reshape(s2,11,11));

figure(1);
surf(reshape(x1,11,11), reshape(x2,11,11), reshape(mu,11,11), 'FaceColor','yellow');
hold on;
surf(reshape(x1,11,11), reshape(x2,11,11), plusSTD,'FaceColor',[19.2/25 19.2/25 19.2/25],'FaceAlpha',0.75);
hold on;
surf(reshape(x1,11,11), reshape(x2,11,11), negativeSTD,'FaceColor',[19.2/25 19.2/25 19.2/25],'FaceAlpha',0.75);
hold on;
plot3(x(:,1), x(:,2), y, 'o+', 'LineWidth', 1);

xlabel('Input 1, x_1','FontSize',14)
ylabel('Input 2, x_2','FontSize',14)
zlabel('Predictive mean, \mu_1','FontSize',14);
legend('Predictive mean','95% predictive error meshgrids', 'FontSize',14);
title('Model 1 hyperparameters: l_1 = 1.51, l_2 = 1.29, \sigma_f = 1.11, \sigma_n = 0.10', 'FontSize',14)