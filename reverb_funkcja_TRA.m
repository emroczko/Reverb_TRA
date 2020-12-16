close all 
clear all


% filtr grzebieniowy 

%[x,fs] = audioread("strat.wav");
[x,fs] = audioread("626.wav");
%[x,fs] = audioread("tele.wav");

x = x(:,1);
x= x.';

B = @(K,a) a.*[1 zeros(1,K-1) 0.6];

D2 = 2175;
D3 = 2350;
D4 = 2550;%oponienie
D5 = 2950;%oponienie

x2 = filter(B(D2,0.7),1,x);
x3 = filter(B(D3,0.7),1,x);
x4 = filter(B(D4,0.7),1,x);
x5 = filter(B(D5,0.7),1,x);

x_r =  x2 + x3 + x4 + x5;

x_r = 0.5.*x_r;



% allpasy
g = 0.7;
d = 1200;

b=[g zeros(1,d-1) 1];
a=[1 zeros(1,d-1) g];

xx = filter(b,a,x_r);

g1 = 0.7;
d1 = 1000;

b1=[g1 zeros(1,d1-1) 1];
a1=[1 zeros(1,d1-1) g1];

xxx = filter(b1,a1,xx);

g2 = 0.5;
d2 = 5000;

b2=[g2 zeros(1,d2-1) 1];
a2=[1 zeros(1,d2-1) g2];

xy = filter(b2,a2,xxx);


x_x = 0.5.*xy + x;






