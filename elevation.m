function el=elevation(ENU,el_mask)
elevation_angles=rad2deg(asin(ENU(:,3)./vecnorm(ENU,2,2)));
valid_elevation=elevation_angles>=el_mask;
elevation_angles(-valid_elevation)=naN;
el=elevation_angles';
end
