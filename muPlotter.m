function[] = muPlotter(mu, pi, noRows, noCols, K, n, r, c )
%% Assumes mu is [noRows*noCols, K]

figure(n)
for i=1:K
    subplot(r, c, i)
    imagesc(reshape(mu(:, i), noRows, noCols))
    title(num2str(pi(i)))
    colormap gray
end    
