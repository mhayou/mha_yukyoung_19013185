function DCM=ECI2ECEF_DCM(time)
jd=juliandate(datetime(time));
UTC_ANGLE = siderealTime(jd)*pi/180;
DCM=[cos(UTC_ANGLE) sin(UTC_ANGLE) 0 ;-sin(UTC_ANGLE) cos(UTC_ANGLE) 0;0 0 1];
end
