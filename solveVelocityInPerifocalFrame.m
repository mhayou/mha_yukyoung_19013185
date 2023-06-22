function velocityInPQW = solveVelocityInPerifocalFrame(semimajor_axis, eccentricity, true_anomaly);
              
            %semimajor_axis[km] , true_anomaly[deg] 
            P=semimajor_axis*(1-eccentricity^2); %P=semi-latus rectum
            mu=3.986004418e+5; %[km^3/s^2]
           
            

            velocityInPQW=sqrt(mu/P)*[-sin(true_anomaly*pi/180);eccentricity+cos(true_anomaly*pi/180);0];
end

       