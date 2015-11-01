BusRoutes = shaperead('CTA_Routes\CTA_Routes.shp');
% BusStops = shaperead('CTA_BusStops\CTA_BusStops.shp');

% for i = 1:length(BusStops)
%     i
%     [BusStops(i,1).X, BusStops(i,1).Y] = sp_proj('illinois east', 'forward', BusStops(i,1).X, BusStops(i,1).Y, 'sf');
% end

RouteTotals = csv2struct('CTA_-_Ridership_-_Bus_Routes_-_Daily_Totals_by_Route.csv');

StopBoards = csv2struct('CTA_-_Ridership_-_Avg._Weekday_Bus_Stop_Boardings_in_October_2012.csv');

RouteTotals.Datevec = cellfun( @(x) datevec(x, 'm/dd/yyyy'), RouteTotals.date, 'UniformOutput', false);

T = RouteTotals;

rm = cellfun(@(x) x(1) ~= 2012 | x(2) ~= 10, T.Datevec);
T.date(rm) = [];
T.daytype(rm) = [];
T.rides(rm) = [];
T.route(rm) = [];
T.Datevec(rm) = [];
T.route = cellfun(@num2str, T.route, 'UniformOutput', false);
T.qtl = zeros(length(T.rides),1);
rs = cell(length(BusRoutes),1);
T.link = zeros(length(T.route),1);
for i = 1:length(rs)
    rs{i} = BusRoutes(i,1).ROUTE;
    bool = cellfun(@(x) strcmp(x, rs{i}), T.route);
    T.link(bool) = i;
end

rm = find(T.link == 0);
T.date(rm) = [];
T.daytype(rm) = [];
T.rides(rm) = [];
T.route(rm) = [];
T.Datevec(rm) = [];
T.link(rm) = [];
T.qtl = zeros(length(T.route),1);

f = figure;
for i = 1:31
    clf
    d = cell2mat(cellfun(@(x) x(3) == i, T.Datevec, 'UniformOutput', false));
    
    qtile = quantile(T.rides(d), [0.25 0.5 0.75]);
    
    q = zeros(length(find(d)), 1);
    q(T.rides(d)<=qtile(1)) = 4;
    q(T.rides(d)>qtile(1) & T.rides(d)<=qtile(2)) = 3;
    q(T.rides(d)>qtile(2) & T.rides(d)<=qtile(3)) = 2;
    q(T.rides(d)>qtile(3)) = 1;
    
    T.qtl(d) = q;
    for j = 4:-1:1
        p = intersect(find(d), find(T.qtl==j));
        switch j
            case 1
                color = 'm';
            case 2
                color = 'r';
            case 3
                color = 'g';
            case 4
                color = 'b';
        end
        for k = 1:length(p)
            geoshow(BusRoutes(T.link(p(k)),1), 'DisplayType', 'Line', 'Color', color);
            hold on;
        end
    end
    [~, DayStr] = weekday(datenum(T.Datevec{p(1)}));
    text( 1190000, 1960000, strcat(DayStr, ' -', num2str(T.Datevec{p(1)}(2)), '/' ,num2str(T.Datevec{p(1)}(3)),'/',num2str(T.Datevec{p(1)}(1)))); 
    
    hold off;
    if i == 1
        set(gca, 'box', 'on');
        set(gca, 'xtick', [], 'ytick', []);
        frame = getframe;
        [im,cmap] = rgb2ind(frame.cdata,512, 'dither');
        im(:,:,1,31) = 0;
    else
        set(gca, 'box', 'on');
        set(gca, 'xtick', [], 'ytick', []);
        frame = getframe;
%         [i,cmap] = rgb2ind(frame.cdata,256);
        im(:,:,1,i) = rgb2ind(frame.cdata, cmap, 'dither');
         
    end
    
%     pause(.5);
        
end

imwrite(im,cmap,'BusRouteQtl.gif','gif', 'Loopcount',inf,'DelayTime',0.5);

StopBoards.routes = cellfun(@num2str, StopBoards.routes, 'UniformOutput', false);

StopBoards.Lat = zeros(length(StopBoards.routes), 1);
StopBoards.Lon = StopBoards.Lat;

spl = cellfun(@(x) strfind(x, ','), StopBoards.location);
spl = mat2cell(spl, ones(length(spl),1));

StopBoards.Lat = cell2mat(cellfun(@(x, y) str2num(x(2:y-1)), StopBoards.location, spl, 'UniformOutput', false));
StopBoards.Lon = cell2mat(cellfun(@(x, y) str2num(x(y+1:end-1)), StopBoards.location, spl, 'UniformOutput', false));

[StopBoards.X, StopBoards.Y] = sp_proj('illinois east', 'forward', StopBoards.Lon, StopBoards.Lat, 'sf');
[~, outlie] = sort(StopBoards.boardings, 'descend');
outlie = outlie(1:100);
z = StopBoards.boardings == 0;
% hist(StopBoards.boardings,3000);
scatter(StopBoards.X, StopBoards.Y, 1,'.', 'k');
hold on;
scatter(StopBoards.X(outlie), StopBoards.Y(outlie), 4, 'r','filled');
scatter(StopBoards.X(z), StopBoards.Y(z), 4, 'b','filled');
axis equal
axis tight
set(gca, 'box', 'on');
set(gca, 'xtick', [], 'ytick', []);
saveas(gcf, 'StopBoards_extrema.png', 'png');