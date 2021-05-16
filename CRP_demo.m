%% DPMM for Clustering
% Generate data from a Finite Mixture model with a Normal base distribuion
% and Gaussian noise
% Do clustering using collapsed Gibbs on Dirichlet Process Mixture Model
% (Chinese Restaurant process)
%% Generating Data (from Finite Mixture Model)
N = 100; % number of data points
K = 6; % number of clusters

pi = gamrnd(9,0.5,1,K); % weight for each cluster
pi = pi/sum(pi);

% generate color for each cluster
color = rand(K,3);
for i = 1:K
    color(i,:) = color(i,:)/sum(color(i,:));
end

theta = normrnd(0,4,2,K); % centers of each cluster from Normal distribution


% cluster assignment
z = zeros(1,N);
for i = 1:N
    z(i) = sample_from_vec(pi);
end

% data generation (Normal distribution with variance 1)
x = zeros(2,N);
for i = 1:N
    x(1,i) = normrnd(theta(1,z(i)),0.5);
    x(2,i) = normrnd(theta(2,z(i)),0.5);
end

figure(1)

% plot cluster
plot(theta(1,:),theta(2,:),'*','MarkerSize',15)
hold on
for i = 1:N
    plot(x(1,i),x(2,i),'.','MarkerSize',15,'color',	color(z(i),:))
    hold on
end
hold off

%% Inference using Chinese Restaurant Process

iter = 2000; % number of iterations

% hyperparameters
tm = 0; % theta mean
ts = 4; % theta variance
dm = 0; % data mean (around theta)
ds = 0.2; % data variance

alpha = 5;


table = cell(1,N); % there can be at most N tables 
table{1} = 1:N; % start with everyone being at table 1

for t = 1:iter
    % Assign new table to customer i
    for i=1:N
        table = get_k_out(table,i);
        list = get_table(table);
        prob = zeros(1,length(list));
        for k = 1:length(list)
            % multiply likelihood by CRP preferential attachment 
            if length(table{list(k)}) > 0 
                % find posterior distribution of center (theta)
                xbar = zeros(1,2);
                for j = 1:length(table{list(k)})
                    c = table{list(k)}(j);
                    xbar = xbar + [x(1,c) x(2,c)];
                end
                xbar = xbar/length(table{list(k)});
                mu = ts^2*xbar/(ds^2/length(table{list(k)}) + ts^2) ... 
                    + (ds^2/length(table{list(k)}))/(ds^2/length(table{list(k)}) + ts^2)*tm;
                tau = (ts^2/length(table{list(k)}))/(ds^2/length(table{list(k)}) + ts^2);
                % use likelihood of marginal posterior
                prob(k) = normpdf(x(1,i),mu(1),tau+1)*normpdf(x(2,i),mu(2),tau+1);
                prob(k) = prob(k)*length(table{list(k)})/(alpha+N-1);
            else 
                prob(k) = normpdf(x(1,i),0,5)*normpdf(x(2,i),0,5);
                prob(k) = prob(k)*alpha/(alpha+N-1);
            end
        end
        % Choose a new table to sit
        prob = prob/sum(prob);
        nt = sample_from_vec(prob);
        table{list(nt)} = [table{list(nt)} i];
    end
end

figure(2)

% plot the resulting cluster (seating arrangement)
list = get_table(table);
for k = 1:length(list)
    if ~isempty(table{list(k)})
        % generate a color
        col = rand(1,3); col = col/sum(col); 
        for j = 1:length(table{list(k)})
            c = table{list(k)}(j);
            plot(x(1,c),x(2,c),'.','MarkerSize',15,'color', col)
            hold on
        end
    end
end

%% Functions

% given a discrete distribution, sample from it and return the index
function ind = sample_from_vec(v)
   c = [0 cumsum(v)];
   xi = rand;
   for i = 1:length(c)-1
       if c(i) < xi && xi < c(i+1), ind = i; break
       end
   end
end

% find customer k and KICK HIM OUT!
function new_table = get_k_out(table, k)
    new_table = cell(1,length(table));
    for i = 1:length(table)
        new_table{i} = table{i}(table{i}~=k);
    end
end

% find the number of existing tables and the index of the next table
function list = get_table(table)
    list = []; next = 0;
    for i = 1:length(table)
        if isempty(table{i}) && next == 0, list = [list i]; next = 1; end
        if ~isempty(table{i}),  list = [list i]; end
    end
end