close
clear
clc

load nav.mat
BDS_a = (nav.BDS.a) / 10^3;         %[km]                                      
BDS_e = nav.BDS.e;                                                  
BDS_p = BDS_a * (1- BDS_e^2);                                       
BDS_i = nav.BDS.i*180/pi;                                         
BDS_arg = nav.BDS.omega*180/pi;                                    
BDS_RAAN = nav.BDS.OMEGA*180/pi;         
BDS_M0 = nav.BDS.M0;                %[rad]                                        
BDS_t = zeros(1440,6);

for i=0:1:1440
    nu(i+1) = true_anomaly(BDS_a, BDS_e, [0 0 0 0 i 0], nav.BDS.toc, BDS_M0);       %[rad]
    BDS_t(i+1,:) = nav.BDS.toc+[0 0 0 0 i 0];
end

BDS_ENU=[0 0 0];

%ground station
lat=37;             %[deg]
lon=127;            %[deg]
h=1;                %[km]
el_mask=10;         %[deg]

BDS_rangeInPQW = zeros(3,1440);
BDS_velocityInPQW = zeros(3,1440);

%24hour in min
for t=1:1:1441
    %PQW range & velocity
    BDS_rangeInPQW(:,t) = solvRangeInPerifocalFrame(BDS_a, BDS_e, nu(t)*180/pi);
    BDS_velocityInPQW(:,t) = solveVelocityInPerifocalFrame(BDS_a, BDS_e, nu(t)*180/pi);
end

    %PQW -> ECI
    BDS_ECI = PQW2ECI(BDS_arg, BDS_i, BDS_RAAN);
    BDS_rangeInECI=BDS_ECI*BDS_rangeInPQW;
    BDS_velocityInECI=BDS_ECI*BDS_velocityInPQW;
    
    %ECI -> ECEF
    BDS_rangeInECEF = zeros(3,1440);
    BDS_velocityInECEF = zeros(3,1440);
    for t=1:1:1441
        DCM=ECI2ECEF_DCM(BDS_t(t,:)); 
        BDS_rangeInECEF(:,t)=DCM*BDS_rangeInECI(:,t); 
        BDS_velocityInECEF(:,t)=DCM*BDS_velocityInECI(:,t);
    end
    
    %ECEF-> geodetic
    wgs84 = wgs84Ellipsoid('kilometer');
    for t=1:1:1441
        [lat(t), lon(t), h(t)]= ecef2geodetic(wgs84, BDS_rangeInECEF(1,t),BDS_rangeInECEF(2,t),BDS_rangeInECEF(3,t));
  
    end


% ground track
figure(1)
geoplot(lat, lon,'y.')
geolimits([-90 90],[-180 180]) %earth angular rate 
legend('BDS')
% orbit
figure(2);
plot3(BDS_rangeInECI(1,:),BDS_rangeInECI(2,:),BDS_rangeInECI(3,:))
 