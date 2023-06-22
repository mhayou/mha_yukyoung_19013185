function nu = true_anomaly(a, e, t, toc, M0)


mu = 398600.4418; 

dt = datetime(t) ;

[h, m, s] = hms(dt);

d_min = h*60 + m + s/60;

% iteration calcutaion of E

n = sqrt(mu/(a^3));

M = n*d_min + M0*pi/180;
E = M;

while(1)

    E_old = E;

    E = M + e*sin(E);
    if abs(E-E_old)<=10^-9
        break
    end
end


nu = 2*atan2(tan(E/2)*sqrt(1+e),sqrt(1-e));

if nu<0
    nu = nu+2*pi;
end

nu = nu*(180/pi);

end