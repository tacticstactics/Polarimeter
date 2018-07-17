%jones_waveplate_thickness_main_2.m

close all;

wavel1 = 1e-6; %wavelength[m]

no = double(1.5); % index of refraction for ordinary ray
ne = double(1.51); % index of refraction for extraordinary ray

is = [1;0]; % input polarization status. holizontal liear polarization

%wp_thickness = [0,0,0]; %[m]
%wp_thickness = [6.25e-6,6.25e-6,6.25e-6]; %[m]
%wp_thickness = [12.5e-6,12.5e-6,12.5e-6]; %[m]
%wp_thickness = [18.75e-6,18.75e-6,18.75e-6]; %[m]
%wp_thickness = [25e-6,25e-6,25e-6]; %[m] 1/2 WP
%wp_thickness = [37.5e-6,37.5e-6,37.5e-6]; %[m]
%wp_thickness = [50e-6,50e-6,50e-6]; %[m]
%wp_thickness = [62.5e-6,62.5e-6,62.5e-6]; %[m]%
%wp_thickness = [75e-6,75e-6,75e-6]; %[m] 3/2 WP
%wp_thickness = [87.5e-6,87.5e-6,87.5e-6]; %[m]
%wp_thickness = [100e-6,100e-6,100e-6]; %[m]

wp_thickness = [0.0e-6, 23e-6, 75e-6]; %[m]

[sizem, sizen] = size(wp_thickness);

%---
% Inplane angle of  Waveplate
theta1 = 45;
Ea_matrix = zeros(2,sizen);

for ii = 1:sizen
Ea_matrix(:,ii) = jones_waveplate_func(wavel1,no,ne,wp_thickness(1,ii),theta1, is);
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
Eb_x = zeros(s,sizen); Eb_y = zeros(s,sizen);

for ii = 1:sizen
for c = 1:s
d1 = 0.000000001*c;

Eb_x(c,ii)=jones_propagate_func(wavel1,1.5,d1,Eb_matrix(1,ii));
Eb_y(c,ii)= jones_propagate_func(wavel1,1.5,d1,Eb_matrix(2,ii));
end
end


hFig1 = figure(1);
set(hFig1, 'Position', [1300 700 500 300])

p1 = plot(real(Eb_x(:,1)),real(Eb_y(:,1)),...
    real(Eb_x(:,2)),real(Eb_y(:,2)),...
    real(Eb_x(:,3)),real(Eb_y(:,3)));

xlim([-1 1]); ylim([-1 1]);

%---

 % Polarimeter is composed of rotating QWP, fixed polarizer and detector.

 Px = zeros(s,sizen); % P: Power
 angle1_col=zeros(s,1); % Angle of QWP

 qwp_thickness = 25e-6;
 
for ii = 1:sizen 
 for cc = 1:s
% 
    angle1 = 2*cc;
    angle1_col(cc,1)= angle1;
   
     Ec=jones_waveplate_func(wavel1,no,ne,qwp_thickness,angle1,Eb_matrix(:,ii));

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

fftPx = fft(Px);

absfftPx = abs(fftPx);
realfftPx = real(fftPx);
imagfftPx = imag(fftPx);
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


hfig3 = figure(3);
set(hfig3, 'Position', [800 400 500 300])
p3 = plot(absfftPx);

%p3=plot(f,P1);
p3(1).Marker = '*'; p3(2).Marker = 'o'; p3(3).Marker = '+';
xlim([0 50])
ylabel('Absolute Intensity')

%---

hfig4 = figure(4);
set(hfig4, 'Position', [800 100 500 300])
p4 = plot(anglefftPx);

p4(1).Marker = '*'; p4(2).Marker = 'o'; p4(3).Marker = '+';
xlim([0 50])
ylabel('Phase/Degree')

