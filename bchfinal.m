clc;close all;
n1 = 15; k = 5; % Codeword length and message length
[gp,t] = bchgenpoly(n1,k);% t is error-correction capability.
SNRd = -5:1:10 ;
disp('snr value')
disp(SNRd)
disp('error correction capability')
disp(t)
disp('gp')
disp(gp)
nw = 100; % Number of words to encode (more data word analysis will take more time)
msgw1 = gf(randi([0 1],nw,k)); % Random k-symbol message generated 
disp('message word')
disp(msgw1)
a=msgw1;
l=reshape(a,1,[]);
disp(l)
h1=length(l);
disp('length of reshaped nsg signal')
disp(h1)
% disp('transmitted message')
% disp(a)
% disp('number of bits per word')
% disp(k)
c = bchenc(msgw1,n1,k);% Encode the data.
b=c;
% disp('encoded value1')
% disp(b)
% de2bi(double(c.x))
z=double(c.x);%convert to double
disp(z)
o=reshape(z,1,[]);%reshape into single row
disp(o)
for n = 1:length(SNRd)
    SNR(n)=10^(SNRd(n)/10); 
   rxSig = awgn(z,SNR(n));
y=int64(rxSig);
y(y<0)=0;
y(y>0)=1;
k=reshape(y,nw,[]);
% disp(k)
  m=gf(k);
disp('gf of rx')
disp(m)  
[dc,nerrs,corrcode] = bchdec(m,15,5); % Decode cnoisy. 
% Check that the decoding worked correctly.
% disp(' corrcode')
g=corrcode;
% disp(g)  
% disp('decoded message') 
f=dc;
% disp(f)
e=reshape(f,1,[]);
% disp(e)
h2=length(e);
% disp('length of rxd signal')
% disp(h2)
%  if corrcode==b
%      disp('error corrected')
%  end
%  if dc==msgw1
%      disp('recovered')
% end
% % chk2 = isequal(dc,msgw1) & isequal(corrcode,b);
% % disp('check whether the same as tx (1=msg recovered,0=error corrected)')
% % disp(chk2)
% % nerrs ; % Find out how many no of errors bchdec corrected .
% % disp('no of errors bchdec corrected')
% % disp(nerrs)
% end
% figure
% subplot(4,1,2)
% plot(nerrs,'-r')
% xlabel('number of words');
% ylabel('No.of errors corrected');
% title('number of errors corrected at each symbol');
% disp('rx error signal')
s=find(l~=e);
% disp(s)
h=length(s);
% disp('length of rxd error signal')
% disp(h)
% disp('bit error rate')
ber3(n)=(h/h1);
disp(SNRd);
disp(ber3);
% h5=nerrs(n);
% disp(h5)
end
% % ber(n)=length(ber);
% % figure
% % axis auto xy
% % plot(SNR(n))
% % figure
% axis auto
% plot(SNR,ber(n),'-r')
% snr, BER_wo_EC, 'b-+'
axis auto
semilogy(SNRd, ber3, 'r*-')
legend('BER with BCH');
xlabel('SNR (dB)'); ylabel('BER'); title('BER Performance of BCH Code');