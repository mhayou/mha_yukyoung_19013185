function ECI=PQW2ECI(arg_prg,inc_angle,RAAN)
% arg_prg = argument of perigee
% inc_angle = inclination angle
% RAAN = right ascension ascending node

R1=[cos(RAAN) -sin(RAAN) 0;sin(RAAN) cos(RAAN) 0;0 0 1];
R2=[1 0 0;0 cos(inc_angle) -sin(inc_angle);0 sin(inc_angle) cos(inc_angle)];
R3=[cos(w) -sin(arg_prg) 0;sin(arg_prg) cos(arg_prg) 0;0 0 1];

ECI=R1*R2*R3;
end

