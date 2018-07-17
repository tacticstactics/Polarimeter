% jones_waveplate_inplane_rotate_main_2b.m

close all;

wavel1 = 1e-6; %[m]
no = double(1.5);
ne = double(1.51);



wp_thickness = 12.5e-6; % 1/8 wp
%wp_thickness = 25e-6; %[m] qwp = 1/4 wp
%wp_thickness = 50e-6; %[m] hwp = 1/2 wp

is = [1;0]; % holizontal liear polarization
%is = [0;1]; % vertical linear polarization


%---
% Waveplate

%theta1 = [-45,-45,-45];
%theta1 = [0,-0,0];
%theta1 = [45,45,45];

theta1 = [0,22.5,-22.5];

[sizem, sizen] = size(theta1);

Ea_matrix = zeros(2,sizen);

for ii = 1:sizen

Ea_matrix(:,ii) = jones_waveplate_func(wavel1,no,ne,wp_thickness,theta1(1,ii), is);
% wavel1, no,ne, octwp,theta1,in

end


%---
% Rotation angle : theta2
theta2 = 0;
Eb_matrix = zeros(2,sizen);

for ii = 1:sizen;

Eb_matrix(:,ii) = jones_faradayrotator_func(theta2, Ea_matrix(:,ii));
    % theta1,in
    
end

%---

s = 720;
Eb_x = zeros(s,sizen);
Eb_y = zeros(s,sizen);

for ii = 1:sizen
for c = 1:s
d1 = 0.0000000009*c;

Eb_x(c,ii)=jones_propagate_func(wavel1,1.5,d1,Eb_matrix(1,ii));
Eb_y(c,ii)= jones_propagate_func(wavel1,1.5,d1,Eb_matrix(2,ii));
end
end



hFig1 = figure(1);
set(hFig1, 'Position', [1300 700 500 300])

p1 = plot(real(Eb_x(:,1)),real(Eb_y(:,1)),...
    real(Eb_x(:,2)),real(Eb_y(:,2)),...
    real(Eb_x(:,3)),real(Eb_y(:,3)));

xlim([-1 1])
ylim([-1 1])
%p1(2).Marker = '*';
%%p1(2).Linewidth = 2;


%---


 Px=zeros(s,sizen);
 angle1_col=zeros(s,1);

 
qwp_thickness = 25e-6;
 
for ii = 1:sizen 
 for cc = 1:s
% 
    angle1 = 2*cc;
    angle1_col(cc,1)= angle1;

    %     
     Ec=jones_waveplate_func(wavel1,no,ne,qwp_thickness,angle1,Eb_matrix(:,ii));
%     

Px(cc,ii) = (abs(Ec(1,1)))^2; % X axis
% 
 end
end
% 

hFig2 = figure(2);
set(hFig2, 'Position', [1300 400 500 300])

p2=plot(angle1_col, Px(:,1),angle1_col, Px(:,2),angle1_col, Px(:,3));
%xlim([0 360])
ylim([0 1])


%---

Fs = 10*s;
T = 1/Fs;
L = s;
t = (0:L-1)*T;

fftPx = fft(Px);
absfftPx = abs(fftPx);

anglefftPx = zeros(s,sizen);

for ii = 1:sizen
for jj = 1:s

    if absfftPx(jj,ii) > 1


        anglefftPx(jj,ii) = angle(fftPx(jj,ii)).*180/pi;

    else
        
        anglefftPx(jj,ii) = 0;
        
    end   

end

end

%for ii = 1:sizen
%Y(:,ii) = abs(fft(Px(:,ii)));
%P2= abs(Y./L);
%P1 = P2(ii,1:s/2+1);
%P1(ii,2:end-1) = 2*P1(ii,2:end-1);
%end

%f = Fs*(0:(L/2))/L;

%---

hfig3 = figure(3);
set(hfig3, 'Position', [800 400 500 300])
p3 = plot(absfftPx);

%p3=plot(f,P1);
p3(1).Marker = '*'; p3(2).Marker = 'o'; p3(3).Marker = '+';

xlim([0 50])

%---

hfig4 = figure(4);
set(hfig4, 'Position', [800 100 500 300])
p4 = plot(anglefftPx);


%p3=plot(f,P1);
p4(1).Marker = '*';p4(2).Marker = 'o';p4(3).Marker = '+';

xlim([0 50])

