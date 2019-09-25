function sensitivityMap = Generate_Sensitivity_Map(filename, gain, offset, boolShowFigs)

filename = 'MethaneCalibrationData_09.13.2019';

[nitrogen, methane] = Load_Sensitivity_Map_Calibration(filename);

% Apply Flat Field Calibration
nitrogen = Apply_Flat_Field_Calibration(nitrogen, gain, offset);
methane  = Apply_Flat_Field_Calibration (methane, gain, offset);

% Compute %Difference pixel by pixel
dif = Compute_Percent_Difference(nitrogen, methane);

% Apply a linear fit
sensitivityMap = Create_Linear_Fit(dif);

%% Display the Data that was processed
if (boolShowFigs == 1)
    oMin = min(rmoutliers(sensitivityMap(:,2),'percentiles',[5 100]));
    oMax = max(rmoutliers(sensitivityMap(:,2),'percentiles',[0 95]));
    clims = [-1, 0.8];
    clims2 = [oMin, oMax];

    figure
    imagesc(sensitivityMap(:,:,1), clims);
    title('slope');
    colorbar
    figure
    imagesc(sensitivityMap(:,:,2), clims2)
    title('y-Intercept')
    colorbar
end

%% More Displays
if (boolShowFigs == 1)
    figure
    for i = 1:99
        imagesc(dif(:,:,i))
        colorbar
        title(num2str(i))
        frame = getframe(gcf);
    end
end