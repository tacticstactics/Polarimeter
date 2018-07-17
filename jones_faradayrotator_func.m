

function [Ea] = jones_faradayrotator_func(theta1,in)

%cw
 T11 = [cos(theta1*pi/180), sin(theta1*pi/180);
   	-sin(theta1*pi/180), cos(theta1*pi/180)];

        
 Ea = T11 * in ;
 
end