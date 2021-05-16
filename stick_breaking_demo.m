%% Part 1: looking at Beta distributions

dx = 0.01;
x = 0:dx:1;

% we plot Beta(1,a) for a few different a's
plot(x,betapdf(x,1,0.5),'linewidth',1.2)
hold on
plot(x,betapdf(x,1,1),'linewidth',1.2)
hold on
plot(x,betapdf(x,1,2),'linewidth',1.2)
hold off
title('Beta densities with different \alpha''s')
legend('\alpha = 0.5','\alpha = 1','\alpha = 2')

%% Part 2: Stick Breaking Construction

iter = 30;
alpha = 6;

dx = 0.001;
x = 0:dx:1;


stick = 1;
len = 0;

for k=1:iter
    rho = betarnd(1,alpha);
    newseg = stick*rho;
    plot(x, line(x, len, len + newseg, iter - k + 1), '.')
    set(gca,'ytick',[])
    ylim([0.01 iter + 1.1])
    xlim([0 1])
    hold on
    xline(len+newseg);
    hold on
    len = len + newseg;
    stick = stick - newseg;
end

%% Part 3: Resulting Distribution

iter = 100;
alpha = 3;
pi = zeros(1,iter);
phi = zeros(1,iter);

dx = 0.0001;
x = -2:dx:2;

stick = 1;
for k=1:iter
    rho = betarnd(1,alpha);
    pi(k) = stick*rho;
    stick = stick - stick*rho;
    phi(k) = normrnd(0,1); % standard normal as base distribution
end

phi = round(phi,4);
for i=1:length(phi)
    y = dirac(x - phi(i));
    idx = y == Inf;
    y(idx) = pi(i); 
    stem(x,y,'color',[0, 0.4470, 0.7410])
    xlim([-3 3])
    ylim([0.0001 0.3])
    hold on
end

function r = line(x, a, b, v)
r = zeros(1,length(x));
for i=1:length(x)
    if a < x(i) && x(i) < b, r(i) = v;
    else, r(i) = 0;
    end
end
end