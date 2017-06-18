clc;clear all;
close all;
db=[1 0 0 1 1];	
 d=2*db-1;
 disp(d)
 dd=repmat(d',1,200) 
 disp(dd)
dw=dd'
disp(dd)
bw=dw(:)'
disp(bw)
x=bw+randn(1,length(bw))*0.1;
n=1000;
w=zeros(1,n);
mu=0.2;
for i=1:n
e(i)=bw(i)-w(i)*x(i);
w(i+1)=w(i)+(mu*e(i)*x(i));
end
for i=1:n
y(i)=w(i).*bw(i);
end
subplot(2,2,1),plot(bw);
ylabel('original signal');
subplot(2,2,2),plot(x);
ylabel('signal added with noise');
subplot(2,2,3),plot(e);
ylabel('error');
subplot(2,2,4),plot(y);
ylabel('adaptive equalizer output');
