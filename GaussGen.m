N_pixCols=28;
N_pixRows=28;
Hvar=1;
Hidden_params=[14, 8;
                10, 22];
sigma_sq=10;

val1=0;
val2=0;

for i=1:4
    Hvar=mod(i,2)+1;
    Pix_rand=rand(N_pixCols, N_pixRows);
    Pix_val=zeros(N_pixCols, N_pixRows);
    [X, Y]=meshgrid(1:N_pixCols, 1:N_pixRows); %[1 2 3...; 1 2 3; ..]
    Pix_prob=exp(-((X-Hidden_params(Hvar, 2)).^2+(Y-Hidden_params(Hvar, 1)).^2)/(2*sigma_sq));
    Pix_prob_norm=(1/(2*pi*sigma_sq))*Pix_prob;
    Pix_prob_norm2=30*Pix_prob_norm/sum(sum(Pix_prob_norm, 1));
    Pix_val([Pix_rand<=Pix_prob_norm2])=1;
    
    val1=val1+Pix_val;
    
    figure(1)
    subplot(2, 2, i)
    imagesc(Pix_val)
%     mu=Hidden_params(Hvar,:);
%     SIGMA=[sigma_sq^0.5 0; 0 sigma_sq^0.5];
%     r = round(mvnrnd(mu,SIGMA,50));
%     Pix_val2=zeros(N_pixRows, N_pixCols);
%     Pix_val2((r(:,2)-1)*28+r(:,1))=1;
%     
%     val2=val2+Pix_val2;
    
end



% figure(2)
% imagesc(Pix_val2)
% length(find(Pix_val2))