function [gain, offset] = Calculate_Flat_Field_Calibration(nitrogen)

X = [(1000:1000:33000)' ones(33,1)];

gain   = zeros(256,320,3);
offset = zeros(256,320,3);

for row = 1:256
    for col = 1:320
        I = squeeze(nitrogen(row,col,1:33))';
        P = I/X';
        gain  (row,col,1) = P(1);
        offset(row,col,1) = P(2);

        I = squeeze(nitrogen(row,col,34:66))';
        P = I/X';
        gain  (row,col,2) = P(1);
        offset(row,col,2) = P(2);
        
        I = squeeze(nitrogen(row,col,67:99))';
        P = I/X';
        gain  (row,col,3) = P(1);
        offset(row,col,3) = P(2);
    end
end