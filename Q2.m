A = csv2struct('C:\ProgramData\MySQL\MySQL Server 5.7\Uploads\DeptFreq.csv');

[t, i] = sort(A.Frequency, 'descend');

ans1 = cell(2,1);
ans1{1} = t(2)/sum(A.Frequency);
ans1{2} = A.AgencyName{i(2)};

clear A;

A = csv2struct('C:\ProgramData\MySQL\MySQL Server 5.7\Uploads\ComplType.csv');
A.Borough = cellfun(@num2str, A.Borough, 'UniformOutput', false);
A.Borough = cellfun(@(x) regexprep(lower(x), '[^a-z]',' '), A.Borough, 'UniformOutput', false');

A.Brooklyn = cellfun(@(x) ~isempty(findstr('brooklyn', x)), A.Borough);
A.Bronx = cellfun(@(x) ~isempty(findstr('bronx', x)), A.Borough);
A.Manhattan = cellfun(@(x) ~isempty(findstr('manhattan', x)), A.Borough);
A.Queens = cellfun(@(x) ~isempty(findstr('queens', x)), A.Borough);
A.SI = cellfun(@(x) ~isempty(findstr('staten island', x)), A.Borough);

B = A;
B.ComplaintType = cellfun(@(x) lower(x), A.ComplaintType, 'UniformOutput', false);
B.ComplaintType = cellfun(@(x) regexprep(x, '[^a-z]',' '), B.ComplaintType, 'UniformOutput', false);

B.TotalsListIdx = cell(length(B.ComplaintType),1);
B.Links = zeros(length(B.ComplaintType), 5);
B = CombineSimilar(B, 'Brooklyn');
B = CombineSimilar(B, 'Bronx');
B = CombineSimilar(B, 'Manhattan');
B = CombineSimilar(B, 'Queens');
B = CombineSimilar(B, 'SI');

t = find(sum(B.Links,2)~=0);

B.Tot(1) = sum(B.Frequency(B.Brooklyn));
B.Tot(2) = sum(B.Frequency(B.Bronx));
B.Tot(3) = sum(B.Frequency(B.Manhattan));
B.Tot(4) = sum(B.Frequency(B.Queens));
B.Tot(5) = sum(B.Frequency(B.SI));
B.CityWide = cellfun(@(x) sum(B.Frequency(x)), B.TotalsListIdx);
B.CityWide = B.CityWide/sum(B.CityWide);
for i = 1:5
    tc = zeros(size(B.Links,1),1);
    temp = B.Links(:,i);
    q = temp>0;
    tc(q) = (B.Frequency(temp(q))/B.Tot(i))./B.CityWide(q);
    B.BPercs(:,i) = tc;
end

[q, i] = max(B.BPercs(:));
[r,c] = ind2sub(size(B.BPercs), i);
ans2 = cell(1,3);
ans2{1} = q;
ans2{2} = B.ComplaintType{B.Links(r,c)};
t = {'Brooklyn', 'Bronx', 'Manhattan', 'Queens', 'StatenIsland'};
ans2{3} = t{c};

clearvars -except ans1 ans2

A = csv2struct('C:\ProgramData\MySQL\MySQL Server 5.7\Uploads\Coords.csv');

[A.Latitude, i]  = sort(A.Latitude);
A.Longitude = A.Longitude(i);
A.Longitude(A.Latitude <40) = [];
A.Latitude(A.Latitude <40) = [];


ans3 = prctile(A.Latitude, 90) - prctile(A.Latitude, 10);

sx = std(A.Longitude);
sy = std(A.Latitude);

%distance at ~40.75N and ~74W, calculated using online tool

a = 46.72;
b = 46.05;

ans4 = pi()*a*b;

% coeff = pca([A.Latitude, A.Longitude]);
% 
% A.x = [A.Latitude, A.Longitude]*coeff(:,1);
% A.y = [A.Latitude, A.Longitude]*coeff(:,2);
% 
% sx = std(A.x);
% sy = std(A.y);
% 
% 
% ans4 = pi()*sx*sy;

A = csv2struct('C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/Times.csv');

B = A;
notdate = cellfun(@(x) sum(strcmp(x(end-1:end), {'AM', 'PM'}))~=1, B.CreatedDate);
B.CreatedDate(notdate) = [];
B.ClosedDate(notdate) = [];
notdate = cellfun(@(x) sum(strcmp(x(end-1:end), {'AM', 'PM'}))~=1, B.ClosedDate);
B.CreatedDate(notdate) = [];
B.ClosedDate(notdate) = [];
B.Datenum = cellfun(@(x) datenum(x), B.CreatedDate);
B.DatenumO = cellfun(@(x) datenum(x), B.ClosedDate);
B.Duration = (B.DatenumO - B.Datenum)*(24*3600);
notreal = (B.Duration<30 | B.Duration > 6*3600);
B.CreatedDate(notreal) = [];
B.ClosedDate(notreal) = [];
B.Datenum(notreal) = [];
B.Hour = cellfun(@(x) x(end-10:end-9), B.CreatedDate, 'UniformOutput', false);
B.Hour = str2num(cell2mat(B.Hour));
aft = cell2mat(cellfun(@(x) strcmp(x(end-1:end), 'PM'), B.CreatedDate, 'UniformOutput', false));
B.Hour(aft) = B.Hour(aft)+12;


values = unique(B.Hour);
instances = histc(B.Hour(:),values);
[instances, i] = sort(instances, 'descend');
values = values(i);

ans5 = instances(1) - instances(end);
B.TimeBetween = -diff(B.Datenum)*24*3600;

ans6 = std(B.TimeBetween);
