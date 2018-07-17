

function [Ea] = jones_waveplate_func(wavel1, no,ne, octwp,theta1,in)

%cw
 T11 = [cos(theta1*pi/180), sin(theta1*pi/180);
   	-sin(theta1*pi/180), cos(theta1*pi/180)];


%phase      
 P1 = [exp((-1j*2*pi*no * octwp)/ wavel1),	0;
       		0,	exp((-1j*2*pi*ne * octwp) / wavel1)];              

%ccw     
 T12 = [cos(-1.* theta1*pi/180), sin(-1.*theta1*pi/180);
   	-sin(-1.* theta1*pi/180), cos(-1.* theta1*pi/180)];
        
 Ea = T12 * P1 * T11 * in ;

 
end