% make a bar plot from vector  and annotate with player names from W

function cw2(P, W);

[kk, ii] = sort(P, 'descend');

np = 20;
barh(kk(np:-1:1))
set(gca,'YTickLabel',W(ii(np:-1:1)),'YTick',1:np,'FontSize',8)
axis([0 1 0.5 np+0.5])
