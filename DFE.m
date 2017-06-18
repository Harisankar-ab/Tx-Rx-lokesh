clc; 
close all;
clear all;
db=[0 1 0 1 1];	
 d=2*db-1;
 dd=repmat(d',1,200)   
dw=dd'
dw=dw(:)'
r=dw+randn(1,length(dw))*0.2;
%r=awgn(dw,10);
disp(r);
 w1=zeros(1,length(dw));
 w1(1)=1;
 w2=zeros(1,length(dw));
 w2(1)=1;
 dk=zeros(1,length(dw));
mu=.001;
for i=1:length(dw)
    x(1,i)=(r(1,i).')* w1(1,i);
    y(1,i)=(dk(1,i).')* w2(1,i);
    z(1,i)=x(1,i)-y(1,i);
    if (z(i))<0
    dk(i)=-1;
    else if (z(i))>=0
      dk(i)=1;
        end
  end
    e(1,i)=z(1,i)-dk(1,i);
w1(1,i+1)=w1(1,i)+mu*e(1,i)*r(1,i);
w2(1,i+1)=w2(1,i)+mu*e(1,i)*dk(1,i);
end
subplot(221),plot(dw),title('Desired Signal');
subplot(222),plot(r),title('Input Signal+Noise');
subplot(223),plot(e),title('Error');
subplot(224),plot(dk),title('output');
