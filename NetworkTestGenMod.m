function[synapse, tmax, InterestingSyns]=NetworkTestGenMod(N_pixCols, N_pixRows, N_states, N_hidden, N_pixels, N_inp, N, ltp, sigma, Hidden_params)


InterestingSyns=0:N_pixels*N_states*N_hidden-1;
TotalSyns=length(InterestingSyns)+2*N_hidden;
synapse=zeros(TotalSyns, 5);
NoOn=30;
tmax=[zeros(1, N_inp) 1*ones(1, N_hidden) 0];

count=1;
for s=1:N_states
    for i=1:N_pixCols
        for j=1:N_pixRows
            for k=1:N_hidden
                if(s==1)
                    w=log(ltp)+log(1-0.75)+log((NoOn/(2*pi*sigma^2))*exp(-((i-Hidden_params(k, 2)).^2+(j-Hidden_params(k, 1)).^2)/(2*sigma^2)));
                else
                    w=log(ltp)+log(1-0.75)+log(1-(NoOn/(2*pi*sigma^2))*exp(-((i-Hidden_params(k, 2)).^2+(j-Hidden_params(k, 1)).^2)/(2*sigma^2)));
                end
%                  w=5*rand(1);
                if(w>0)
                    synapse(count, :)=[(s-1)*N_pixCols*N_pixRows+(i-1)*N_pixCols+j; N_inp+k; w; 0; 1];
                else
                    synapse(count, :)=[(s-1)*N_pixCols*N_pixRows+(i-1)*N_pixCols+j; N_inp+k; 0; 0; 1];
                end
                count=count+1;
            end
        end
    end
end

for k=1:N_hidden
    synapse(count, :)=[N_inp+k; N; 0; 0; 0];
    count=count+1;
end

for k=1:N_hidden
    synapse(count, :)=[N; N_inp+k; -400; 0; 0];
    count=count+1;
end

