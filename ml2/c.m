four_mean = [samples(16,100), samples(1,100),samples(5,100), samples(11,100)]
four_var = [var(samp(16,:)), var(samp(1,:)), var(samp(5,:)), var(samp(11,:))]

prob_winning_marginal = [];
prob_winning_joint = [];

for i=1:4
    prob_winning_marginal_player =[0, 0, 0, 0];
    prob_winning_joint_player = [0, 0, 0, 0];
    for j=1:4
        if (i == j)
            prob_winning_marginal_player(i) = 1;
            prob_winning_joint_player(i) = 1;
        else
            mean1 = four_mean(i);
            mean2 = four_mean(j);
            var1 = four_var(i);
            var2 = four_var(j);
            
            marginal_eval = (mean1 - mean2)/sqrt(var1+var2);
            joint_eval = (mean1 - mean2)/sqrt(1+var1 + var2);
            
            prob_winning_marginal_player(j) = normcdf(marginal_eval);
            prob_winning_joint_player(j) = normcdf(joint_eval);
        end
    end
    prob_winning_joint_player;
    prob_winning_marginal_player
end