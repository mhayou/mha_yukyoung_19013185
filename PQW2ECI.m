function ECI=PQW2ECI(arg_prg,inc_angle,RAAN)
% arg_prg = argument of perigee[deg]
% inc_angle = inclination angle[deg]
% RAAN = right ascension ascending node[deg]

arg_prg2rad=arg_prg*pi/180;
inc_angle2rad=inc_angle*pi/180;
RAAN2rad=RAAN*pi/180;


R1=[cos(RAAN2rad) -sin(RAAN2rad) 0;sin(RAAN2rad) cos(RAAN2rad) 0;0 0 1];
R2=[1 0 0;0 cos(inc_angle2rad) -sin(inc_angle2rad);0 sin(inc_angle2rad) cos(inc_angle2rad)];
R3=[cos(arg_prg2rad) -sin(arg_prg2rad) 0;sin(arg_prg2rad) cos(arg_prg2rad) 0;0 0 1];

ECI=R1*R2*R3;
end

