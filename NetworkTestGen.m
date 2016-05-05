%% Defining the network
% 2 input neurons and 1 output neuron


function[synapse_o, tmax, pattern, InterestingSyns]=NetworkTestGen(N_PN, N, Non)
N_KC=N-N_PN;
% if(Non*14.4/(Non-1)<18.8)
%     gPN_KCmax=14.4/(Non-1); %For a total weight of 14.4, maximum voltage reaches 0.1999, for 18.8 it causes a double spike
% else
%     gPN_KCmax=18.8/Non;
% end



gPN_KCmin=14.4/Non;
gKC_KC=-50;
delayPN_KC=0;
delayKC_KC=0;
epsi=1e-12;

%STDP Window Default
tmax=[zeros(1, N_PN) 0.01325*ones(1, N-N_PN)];
pattern=nchoosek((1:N_PN), Non);
%pattern=pattern(1:4,:);
InterestingSyns=0:N_PN*N_KC-1;
TotalSyns=N_PN*N_KC+N_KC*(N_KC-1);

synapse_o=zeros(TotalSyns,5);
k=0;

for i=1:N_PN
    for j=N_PN+1:N
        k=k+1;
        %synapse_o(k, :)=[i; j; gPN_KCmin+(gPN_KCmax-gPN_KCmin)*rand(1); delayPN_KC; 1];
        synapse_o(k, :)=[i; j; 4; delayPN_KC; 1];
    end
end

for j=N_PN+1:N
    for i=N_PN+1:N
        if(i~=j)
            k=k+1;
            synapse_o(k,:)=[j; i; gKC_KC; delayKC_KC; 0];
        end
    end
end

%Success Case
% synapse_o(1,:)=[1; 4; 8.2558; delayPN_KC; 1];
% synapse_o(2,:)=[1; 5; 8.2017; delayPN_KC; 1];
% synapse_o(3,:)=[1; 6; 8.1877; delayPN_KC; 1];
% synapse_o(4,:)=[2; 4; 8.8838; delayPN_KC; 1];
% synapse_o(5,:)=[2; 5; 8.6314; delayPN_KC; 1];
% synapse_o(6,:)=[2; 6; 8.6224; delayPN_KC; 1];
% synapse_o(7,:)=[3; 4; 8.6583; delayPN_KC; 1];
% synapse_o(8,:)=[3; 5; 8.1771; delayPN_KC; 1];
% synapse_o(9,:)=[3; 6; 8.6258; delayPN_KC; 1];

%Fail Case
% synapse_o(1,:)=[1; 4; 8.4018080337519; delayPN_KC; 1];
% synapse_o(2,:)=[1; 5; 8.07596669169084; delayPN_KC; 1];
% synapse_o(3,:)=[1; 6; 8.23991615355366; delayPN_KC; 1];
% synapse_o(4,:)=[2; 4; 8.12331893483517; delayPN_KC; 1];
% synapse_o(5,:)=[2; 5; 8.18390778828242; delayPN_KC; 1];
% synapse_o(6,:)=[2; 6; 8.23995252566490; delayPN_KC; 1];
% synapse_o(7,:)=[3; 4; 8.41726706908437; delayPN_KC; 1];
% synapse_o(8,:)=[3; 5; 8.04965443032574; delayPN_KC; 1];
% synapse_o(9,:)=[3; 6; 8.90271610991528; delayPN_KC; 1];

%synapse_o(1:6,3)=[6.2437844;6.0597768;5.9521532;5.5529537;5.0604835;5.3845978];
end


