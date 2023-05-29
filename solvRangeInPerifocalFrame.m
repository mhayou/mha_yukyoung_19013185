function rangelnPQW=solvRangeInPerifocalFrame(semimajor_axis,eccentricity,true_anomaly)
             

            %semimajor_axis[km] , true_anomaly[deg] 
            P=semimajor_axis*(1-eccentricity^2); %P=semi-latus rectum
         
            r=P/(1+eccentricity*cos(true_anomaly*pi/180));
           
         
         rangelnPQW=[r*cos(true_anomaly*pi/180);r*sin(true_anomaly*pi/180);0];
          
end
