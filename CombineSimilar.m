function [ A ] = CombineSimilar( A, Borough )


BoroughIdx = find(A.(Borough) == 1);
ex = [];
bidx = [];
switch Borough
    case 'Brooklyn'
        bidx = 1;
    case 'Bronx'
        bidx = 2;
    case 'Manhattan'
        bidx = 3;
    case 'Queens'
        bidx = 4;
    case 'SI'
        bidx = 5;
end

for i = 1:length(BoroughIdx)
    if ~ismember(BoroughIdx(i), ex)
        Recur = A.(Borough).*cellfun(@(x) ~isempty(findstr(lower(A.ComplaintType{BoroughIdx(i)}), lower(x))), A.ComplaintType);
        RecurIdx = find(Recur);
        A.Frequency(BoroughIdx(i)) = sum(A.Frequency(RecurIdx));
        A.Frequency(RecurIdx(2:end)) = 0;
        ex = [ex; RecurIdx];
        A.(Borough)(RecurIdx(2:end)) = 0;
        A.Borough{BoroughIdx(i)} = Borough;
        p = find(cellfun('length',regexp(A.ComplaintType,A.ComplaintType{BoroughIdx(i)})) == 1,1);
        
        A.TotalsListIdx{p} = [A.TotalsListIdx{p};RecurIdx];
        A.Links(p,bidx) = BoroughIdx(i);
    end
end

end

