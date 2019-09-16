function Compare_Cubes(firstCube, secondCube, framesUsedF, framesUsedS)

firstCube  = firstCube (:,321:640,1:framesUsedF,:);
secondCube = secondCube(:,1:320,1:framesUsedS,:);

 figure
for row = 100:150
    for col = 50:200
        signal = [squeeze(firstCube(row,col,:,1)); squeeze(secondCube(row,col,:,1))];
        signal = signal - mean(signal, 'omitnan');
        d10 = [-((10*squeeze(firstCube(row,col,:,2)))+squeeze(firstCube(row,col,:,3)))/100; -((10*squeeze(secondCube(row,col,:,2)))+squeeze(secondCube(row,col,:,3)))/100];
        d25 = [-((25*squeeze(firstCube(row,col,:,2)))+squeeze(firstCube(row,col,:,3)))/100; -((25*squeeze(secondCube(row,col,:,2)))+squeeze(secondCube(row,col,:,3)))/100];
        d50 = [-((50*squeeze(firstCube(row,col,:,2)))+squeeze(firstCube(row,col,:,3)))/100; -((50*squeeze(secondCube(row,col,:,2)))+squeeze(secondCube(row,col,:,3)))/100];
        plot(1:framesUsedS+framesUsedF, signal)
        
        hold on
        plot(1:framesUsedS+framesUsedF, d10)
        plot(1:framesUsedS+framesUsedF, d25)
        plot(1:framesUsedS+framesUsedF, d50)
        hold off
        ylim([-0.5, 0.5])
        xlim([1,framesUsedS+framesUsedF])
        title(['Row: ', num2str(row), 'Col: ', num2str(col)])
        xlabel('Frame Number')
        ylabel('Intensity, normalized with mean removed')
        legend('Intensity Signal', '10cm of methane', '25cm of methane', '50cm of methane')
        frame = getframe(gcf);
    end
end