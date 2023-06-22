close
clear
clc

load nav.mat
QZSS_a = (nav.QZSS.a) / 10^3;         %[km]                                      
QZSS_e = nav.QZSS.e;                                                  
QZSS_p = QZSS_a * (1- QZSS_e^2);                                       
QZSS_i = nav.QZSS.i*180/pi;                                         
QZSS_arg = nav.QZSS.omega*180/pi;                                    
QZSS_RAAN = nav.QZSS.OMEGA*180/pi;         
QZSS_M0 = nav.QZSS.M0;                %[rad]                                        
QZSS_t = zeros(1440,6);

for i=0:1:1440
    nu(i+1) = true_anomaly(QZSS_a, QZSS_e, [0 0 0 0 i 0], nav.QZSS.toc, QZSS_M0);       %[rad]
    QZSS_t(i+1,:) = nav.QZSS.toc+[0 0 0 0 i 0];
end

QZSS_ENU=[0 0 0];

%ground station
lat=37;             %[deg]
lon=127;            %[deg]
h=1;                %[km]
el_mask=10;         %[deg]

QZSS_rangeInPQW = zeros(3,1440);
QZSS_velocityInPQW = zeros(3,1440);

%24hour in min
for t=1:1:1441
    %PQW range & velocity
    QZSS_rangeInPQW(:,t) = solvRangeInPerifocalFrame(QZSS_a, QZSS_e, nu(t)*180/pi);
    QZSS_velocityInPQW(:,t) = solveVelocityInPerifocalFrame(QZSS_a, QZSS_e, nu(t)*180/pi);
end

    %PQW -> ECI
    QZSS_ECI = PQW2ECI(QZSS_arg, QZSS_i, QZSS_RAAN);
    QZSS_rangeInECI=QZSS_ECI*QZSS_rangeInPQW;
    QZSS_velocityInECI=QZSS_ECI*QZSS_velocityInPQW;
    
    %ECI -> ECEF
    QZSS_rangeInECEF = zeros(3,1440);
    QZSS_velocityInECEF = zeros(3,1440);
    for t=1:1:1441
        DCM=ECI2ECEF_DCM(QZSS_t(t,:)); 
        QZSS_rangeInECEF(:,t)=DCM*QZSS_rangeInECI(:,t); 
        QZSS_velocityInECEF(:,t)=DCM*QZSS_velocityInECI(:,t);
    end
    
    %ECEF-> geodetic
    wgs84 = wgs84Ellipsoid('kilometer');
    for t=1:1:1441
        [lat(t), lon(t), h(t)]= ecef2geodetic(wgs84, QZSS_rangeInECEF(1,t),QZSS_rangeInECEF(2,t),QZSS_rangeInECEF(3,t));
  
    end


% ground track
figure(1)
geoplot(lat, lon,'y.')
geolimits([-90 90],[-180 180]) %earth angular rate 
legend('QZSS')
% orbit
figure(2);
plot3(QZSS_rangeInECI(1,:),QZSS_rangeInECI(2,:),QZSS_rangeInECI(3,:))
 