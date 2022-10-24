load tennis_data

randn('seed',27); % set the pseudo-random number generator seed

M = size(W,1);            % number of players
N = size(G,1);            % number of games in 2011 season 

pv = 0.5*ones(M,1);           % prior skill variance 

w = zeros(M,1);               % set skills to prior mean
samples = zeros(M,iter);
samp = zeros(M,iter);
for i = 1:iter

  % First, sample performance differences given the skills and outcomes
  
  t = nan(N,1); % contains a t_g variable for each game
  for g = 1:N   % loop over games
    s = w(G(g,1))-w(G(g,2));  % difference in skills
    t(g) = randn()+s;         % performace difference sample
    while t(g) < 0  % rejection sampling: only positive perf diffs accepted
      t(g) = randn()+s; % if rejected, sample again
    end
  end 
 
  
  % Second, jointly sample skills given the performance differences
  
  m = nan(M,1);  % container for the mean of the conditional 
                 % skill distribution given the t_g samples
  for p = 1:M
    m(p) = 0;
    for g = 1:N
        if( p == G(g,1))
            m(p) = m(p) + t(g);
        elseif (p == G(g,2))
            m(p) = m(p) - t(g);
        else
            continue
        end
        
    end
    % (***TO DO***) complete this line
  end
  
  iS = zeros(M,M); % container for the sum of precision matrices contributed
                   % by all the games (likelihood terms)
  for g = 1:N
      I = G(g,1);
      J = G(g,2);
      iS(I,I) = iS(I,I) + 1;
      iS(J,J) = iS(J,J) + 1;
      iS(I,J) = iS(I,J) - 1;
      iS(J,I) = iS(J,I) - 1;
  end

  iSS = diag(1./pv) + iS; % posterior precision matrix
  % prepare to sample from a multivariate Gaussian
  % Note: inv(M)*z = R\(R'\z) where R = chol(M);
  iR = chol(iSS);  % Cholesky decomposition of the posterior precision matrix
  mu = iR\(iR'\m); % equivalent to inv(iSS)*m but more efficient
    
  % sample from N(mu, inv(iSS))
  w = mu + iR\randn(M,1);
  
  if (i == 1)
      samples(:,1) = w;
      samp(:,1) = w;
  else
    samples(:,i) = (samples(:,i-1)*(i-1) + w)/i;
    samp(:,i) = w;
  end
  
end

Nad = xcov(samp(1,:), 100, 'coeff');
Mur = xcov(samp(11,:), 100, 'coeff');
Djo = xcov(samp(16,:), 100, 'coeff');
Fed = xcov(samp(5,:), 100, 'coeff');

figure
plot(samples(1,:), 'DisplayName','Rafael Nadal')
hold on
plot(samples(11,:), 'DisplayName', 'Andy Murray')
plot(samples(16,:), 'DisplayName', 'Novak Djokovic' )
plot(samples(5,:), 'DisplayName', 'Roger Federer')
legend show
hold off