function calibrated = Apply_Flat_Field_Calibration(uncalibrated, gain, offset)

calibrated = (double(uncalibrated)-offset)./gain;