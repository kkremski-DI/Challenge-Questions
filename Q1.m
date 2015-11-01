
ans1 = Rand_Walk(10,3, 'max')/4^10;
ans2 = Rand_Walk(60,10, 'max')/4^60;

ans3 = 0;
norm = 0;
for i = 1:10
    ans3 = ans3 + Rand_Walk(i,5, 'max');
    norm = norm + 4^i;
end
ans3 = ans3/norm;

ans4 = 0;
norm = 0;
for i = 1:60
    ans4 = ans4 + Rand_Walk(i,10, 'max');
    norm = norm + 4^i;
end
ans4 = ans4/norm;

ans5 = traverse_grid_x(0, 10, 0, -1)/4^10;

t = zeros(1,15);

for i = 6:20
    t(i-5) = traverse_grid_x(0,i,0,-1);
end
f = polyfit(log10([13:20]), log10(t(8:end)), 1);
ans6 = 10^(f(1).*log10(30)+f(2))/(4^30);
plot([6:20], t);
hold on;
plot(f);
axis([0,40, 0, .25]);

dist = 0;
ans7 = 0;
while dist < 10
    ans7 = ans7+1;
    dist = Rand_Walk(ans7,0, 'rms');
end

dists = 0;
ans8 = 0;
x = 0;
time = 0;
while abs(dists(end)-60)>0.1 && ~isnan(dists(end)) && time < 20 
    tic
    dists = [dists, Rand_Walk(ans8,0, 'rms')];
    ans8 = ans8+ floor(60-dists(end));
    x = [x, ans8];
    time = toc;
end

dists(isnan(x)) = [];
x(isnan(x)) = [];


if dists(end)<60
    j = find(dists>7,1);
    f2 = polyfit(log10(dists(j+1:end)),log10(x(j+1:end)), 1);
    

    ans8 = 10^(f2(1)*log10(60)+f2(2));
end