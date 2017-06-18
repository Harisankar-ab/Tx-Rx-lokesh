clc;
clear;
n=63;  %RS codeword length
k=51;  %Number of data symbols
b=12;  %Number of symbols that is expected to be corrupted by the channel
%____________________________________________
p=n-k;  %Number of parity symbols
t=p/2; %Error correction capability of RS code
fprintf('Given (%d,%d) Reed Solomon code can correct : %d symbols \n',n,k,fix(t));
fprintf('Given - expected burst error length from the channel : %d symbols \n',b);
disp('____________________________________________________________________________');
if b <= p
    fprintf('Interleaving  MAY help in this scenario\n');
else
    fprintf('Interleaving will NOT help in this scenario\n');
end
disp('____________________________________________________________________________');
D=ceil(b/t)+1; %Intelever Depth
memory = zeros(D,n); %constructing block interleaver memory
data='THE_QUICK_BROWN_FOX_JUMPS_OVER_THE_LAZY_DOG_'; % A constant pattern used as a data
%If n&amp;gt;length(data) then repeat the pattern to construct a data of length 'n'
data=char([repmat(data,[1,fix(n/length(data))]),data(1:mod(n,length(data)))]);
%We sending D blocks of similar data
intlvrInput=repmat(data(1:n),[1 D]); 
fprintf('Input Data to the Interleaver -&amp;gt; \n');
disp(char(intlvrInput));
disp('____________________________________________________________________________'); 
%INTERLEAVER
%Writing into the interleaver row-by-row
for index=1:D
    memory(index,1:end)=intlvrInput((index-1)*n+1:index*n);
end
intlvrOutput=zeros(1,D*n);
%Reading from the interleaver column-by-column
for index=1:n
    intlvrOutput((index-1)*D+1:index*D)=memory(:,index);
end
%Create b symbols error at 25th Symbol location for test in the interleaved output
%'*' means error in this case
intlvrOutput(1,25:24+b)=zeros(1,b)+42;
fprintf('\nInterleaver Output after being corrupted by %d symbol burst error - marked by ''*''-&amp;gt;\n',b);
disp(char(intlvrOutput));
disp('____________________________________________________________________________');
%Deinteleaver
deintlvrOutput=zeros(1,D*n);
%Writing into the deinterleaver column-by-column
for index=1:n
    memory(:,index)=intlvrOutput((index-1)*D+1:index*D)';
end
%Reading from the deinterleaver row-by-row
for index=1:D
    deintlvrOnput((index-1)*n+1:index*n)=memory(index,1:end);
end
fprintf('Deinterleaver Output-&amp;gt;\n');
disp(char(deintlvrOnput));
disp('____________________________________________________________________________');