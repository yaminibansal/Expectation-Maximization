function[] = muPlotter(mu, pi, noRows, noCols, K, n, r, c )
%% Assumes mu is [noRows*noCols, K]
[piTemp, Ind]=sort(pi, 'descend');
muTemp=(mu(:,Ind));

figure(n)
for i=1:K
    subplot(r, c, i)
    imagesc(reshape(muTemp(:, i), noRows, noCols))
    title(num2str(piTemp(i)))
    colormap gray
end    
