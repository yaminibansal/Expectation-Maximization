%% Checking which neurons fire in less than 4% of all input images
%% for different max pixel values
function[Indices]=GaussianFourPercent(NoOn, N_pixCols, N_pixRows, sigma_sq, Hidden_params)

NoImages=10000;
[X, Y]=meshgrid(1:N_pixCols, 1:N_pixRows); %[1 2 3...; 1 2 3; ..]
Pix_val_sum=0;

for i=1:NoImages
    for Hvar=1:size(Hidden_params, 1);
        Pix_rand=rand(N_pixCols, N_pixRows);
        Pix_val=zeros(N_pixCols, N_pixRows);
        Pix_prob=exp(-((X-Hidden_params(Hvar, 2)).^2+(Y-Hidden_params(Hvar, 1)).^2)/(2*sigma_sq));
        Pix_prob_norm=(1/(2*pi*sigma_sq))*Pix_prob;
        Pix_prob_norm2=NoOn*Pix_prob_norm/sum(sum(Pix_prob_norm, 1));
        Pix_val([Pix_rand<=Pix_prob_norm2])=1;
        Pix_val_sum=Pix_val_sum+Pix_val;
    end
end

Pix_val_sum=Pix_val_sum/NoImages;
Indices=Pix_val_sum<0.04;
