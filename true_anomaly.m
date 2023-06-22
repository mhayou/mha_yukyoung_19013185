function nu = true_anomaly(a, e, t, toc, M0)


mu = 398600.4418; 

% dt = datetime(t);
% 
% [h, m, s] = hms(dt);

d_mins = t(5);

% iteration calcutaion of E

n = sqrt(mu/(a^3))*60;

M = n*d_mins + M0;
E = M;

while(1)

    E_old = E;

    E = M + e*sin(E_old);
    if abs(E-E_old)<=10^-9
        break
    end
end
cosnu = (cos(E)-e)/(1-e*cos(E));
sinnu = sqrt(1-e^2)*sin(E)/(1-e*cos(E));

nu = atan2(sinnu, cosnu);
% nu = atan2(tan(E/2)*sqrt(1+e),sqrt(1-e));

if nu<0
    nu = nu+2*pi;
end

