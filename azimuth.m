function az=azimuth(ENU)
ENU_rad=deg2rad(ENU);
az_rad=atan2(ENU_rad(:,1),ENU_rad(:,2));
az_deg=rad2deg(az_rad);
az_deg= mod(az_deg+360,360);
az=az_deg'; 
end
