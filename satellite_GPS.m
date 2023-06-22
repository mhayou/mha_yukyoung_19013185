close
clear
clc

load nav.mat
GPS_a = (nav.GPS.a) / 10^3;         %[km]                                      
GPS_e = nav.GPS.e;                                                  
GPS_p = GPS_a * (1- GPS_e^2);                                       
GPS_i = nav.GPS.i*180/pi;                                         
GPS_arg = nav.GPS.omega*180/pi;                                    
GPS_RAAN = nav.GPS.OMEGA*180/pi;         
GPS_M0 = nav.GPS.M0;                %[rad]                                        
GPS_t = zeros(1440,6);

for i=0:1:1440
    nu(i+1) = true_anomaly(GPS_a, GPS_e, [0 0 0 0 i 0], nav.GPS.toc, GPS_M0);       %[rad]
    GPS_t(i+1,:) = nav.GPS.toc+[0 0 0 0 i 0];
end

GPS_ENU=[0 0 0];

%ground station
lat=37;             %[deg]
lon=127;            %[deg]
h=1;                %[km]
el_mask=10;         %[deg]

GPS_rangeInPQW = zeros(3,1440);
GPS_velocityInPQW = zeros(3,1440);

%24hour in min
for t=1:1:1441
    %PQW range & velocity
    GPS_rangeInPQW(:,t) = solvRangeInPerifocalFrame(GPS_a, GPS_e, nu(t)*180/pi);
    GPS_velocityInPQW(:,t) = solveVelocityInPerifocalFrame(GPS_a, GPS_e, nu(t)*180/pi);
end

    %PQW -> ECI
    GPS_ECI = PQW2ECI(GPS_arg, GPS_i, GPS_RAAN);
    GPS_rangeInECI=GPS_ECI*GPS_rangeInPQW;
    GPS_velocityInECI=GPS_ECI*GPS_velocityInPQW;
    
    %ECI -> ECEF
    GPS_rangeInECEF = zeros(3,1440);
    GPS_velocityInECEF = zeros(3,1440);
    for t=1:1:1441
        DCM=ECI2ECEF_DCM(GPS_t(t,:)); 
        GPS_rangeInECEF(:,t)=DCM*GPS_rangeInECI(:,t); 
        GPS_velocityInECEF(:,t)=DCM*GPS_velocityInECI(:,t);
    end
    
    %ECEF-> geodetic
    wgs84 = wgs84Ellipsoid('kilometer');
    for t=1:1:1441
        [lat(t), lon(t), h(t)]= ecef2geodetic(wgs84, GPS_rangeInECEF(1,t),GPS_rangeInECEF(2,t),GPS_rangeInECEF(3,t));
  
    end


% ground track
figure(1)
geoplot(lat, lon,'y.')
geolimits([-90 90],[-180 180]) %earth angular rate 
legend('GPS')
% orbit
figure(2);
plot3(GPS_rangeInECI(1,:),GPS_rangeInECI(2,:),GPS_rangeInECI(3,:))
