function sensitivityMap = Create_Linear_Fit(dif)

% the density index is essentially a map that tells the linear fit equation
% what the column density of each %difference is at each location, the
% other half is for the linear fit line equation. 
densityIDX   = [ones(31,1)*10.16; ones(31,1)*25; ones(31,1)*50];
densityIDX   = [densityIDX, ones(93,1)];
sensitivityMap = zeros(256,320,2);
for row = 1:256
    for col = 1:320
        difference = squeeze(dif(row,col,:))';
        sensitivityMap(row,col,:) = difference/densityIDX';
    end
end