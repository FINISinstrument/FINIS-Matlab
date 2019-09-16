function [minY, maxY] = Detirmine_Y_Limits(iPPFy)
%Detirmine_Y_Limits Measure how much veering we will actually do
minY = 0;
maxY = 0;
curLoc = 0;
for i = 1:size(iPPFy,2)
    curLoc = curLoc + iPPFy(i);
    if(curLoc > maxY)
        maxY = curLoc;
    end
    if(curLoc < minY)
        minY = curLoc;
    end
end


