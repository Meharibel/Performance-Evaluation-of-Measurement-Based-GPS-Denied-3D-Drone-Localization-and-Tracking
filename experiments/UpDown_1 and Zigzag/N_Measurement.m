% clear all
% %%======
% sensor_xyz_plotLauri_F
close all
t =20;
d1 = [[0 -7 6];[0 -3 6];[0 1 6];[0 5 6];[0 -5 2];[0 -1 2];[0 3 2];[0 7 2];[0 -7 -2];[0 -3 -2];[0 1 -2];[0 5 -2];[0 -5 -6];[0 -1 -6];[0 3 -6];[0 7 -6]]/8;
nrAnteElem= length(d1(:,1));
% load GPS.mat
load Sig20.mat;
[a,b,c] = size(meas);
dt = 0.5;
SamplingTime=0.5:0.5:a/2;
t=(SamplingTime);
n = numel(t);
% load GPS20R2_new.mat
% x =table2array(X);
% [a,b,~]=size(x); 
SamplingTime=0.5:0.5:50; 
% x=[x(:,1),x(:,2),x(:,3)];
% % x(:,2)=rand(a,1);
% GP=x;
% GP(:,1)=-GP(:,1);
r=1;
t1=30;
lamdaScale = 1;c = 299792458 ;f = 490.0e6;lamda = c./f;
L = 0.3059; %lamda/2; %0.1529*2; % antenna length, half wavelength antenna
k1 = 1/((lamda/2)*lamdaScale);
% Computes the arrival signal
elementsLocations = d1;
deg2rad = pi/180;
G = 1;
N_array=input('Enter the number of arrays = ');
x_spacing = input('Enter the spacing between each array = ');
x_array = 0:x_spacing:(N_array-1)*x_spacing;
y_array = zeros(1, N_array);
z_array = 2.1*ones(1, N_array);
for j =1:50
    for  k =1:N_array% To consider first array and second array
        x1= x_array(k);
        y1=y_array(k);
        z1=z_array(k);
        if k ==1 %consider first array
            Rx_signal1  = (meas(j,1:16,1)+1j*meas(j,1:16,2)).';
        else
            Rx_signal1  = (meas(j,17:32,1)+1j*meas(j,17:32,2)).';
        end
        Rxx = Rx_signal1*Rx_signal1';
        [u,Sigma,v]= svd(Rxx);
        [tmp,sortOrder] = sort(diag(Sigma));
        tmpU = u(:,2:end);
        % MUSIC search for the arrival direction
        eta = 1e-11;
        tmpPHI = [-90+eta:0.1:90]*deg2rad;
        PHI = tmpPHI;
        THETA = zeros(size(PHI));
        phi = -pi/2+eta:pi/100:pi/2; % azimute
        theta = (-pi/2+eta):pi/100:(pi/2); % elevation
        [THETA,PHI]=meshgrid(theta,phi);
        lamdaScaleIn = 1;
        G = MUSICBelay(tmpU, elementsLocations, PHI, THETA, lamdaScaleIn);
        [~,V] = max(G(:));
        Elevation1 = THETA(V);
        Azimuth1 = PHI(V);
        z_M1 =max(G(:));
%         if (GP(j,1)) < 0
%             Azimuth1 = pi-Azimuth1 ;
%         end
        AoA1(j,:) = [Azimuth1;Elevation1];
        y_E =r*cos(Elevation1)*cos(Azimuth1);
        x_E=r*cos(Elevation1)*sin(Azimuth1);
        z_E= r*sin(-Elevation1);% This is correct

        a1(j)=x_E/sqrt((x_E)^2+(y_E)^2+(z_E)^2);
        a2(j)=y_E/sqrt((x_E)^2+(y_E)^2+(z_E)^2);
        a3(j)=z_E/sqrt((x_E)^2+(y_E)^2+(z_E)^2);

        A(k,:)=[a1(j)*t1+x1,a2(j)*t1+y1,a3(j)*t1+z1];
        B(k,:)=[ x1,y1,z1]; %starting point
    end
    [X,P,R,x,p,l] = lineXline(B,A);
    X_1(j,:)=X;

end
% figure(1)
% % subplot(3,1,1)
% plot(SamplingTime, GP(:,1), 'LineWidth', 1.5);grid on;
% hold on;
% plot(SamplingTime,  X_1(:,1), '--', 'LineWidth', 1.5);grid on;
% % plot(SamplingTime, X_EKF(:,1)','k', 'LineWidth', 1.5);grid on;
% hold off;
% grid on;
% % xlim([0 212]);%ylim([-25 20])
% xlabel('Sampling time [s]');ylabel('X [m]')
% legend('GPS trajectory', 'Triangulation trajectory')%,'EKF estimated trajectory');
% figure(2)
% % subplot(3,1,2)
% plot(SamplingTime, GP(:,2), 'LineWidth', 1.5);grid on;
% hold on;
% plot(SamplingTime,  X_1(:,2), '--', 'LineWidth', 1.5);grid on;
% % plot(SamplingTime, X_EKF(:,2)','k', 'LineWidth', 1.5);grid on;
% % xlim([0 212]);
% hold off;
% grid on;
% xlabel('Sampling time [s]');ylabel('Y [m]')
% legend('GPS trajectory', 'Triangulation trajectory');%,'EKF estimated trajectory');% figure(3)
% figure(3)
% % subplot(3,1,3)27
% plot(SamplingTime,GP(:,3), 'LineWidth', 1.5);grid on;
% hold on;
% plot(SamplingTime,  X_1(:,3), '--', 'LineWidth', 1.5);grid on;
% % plot(SamplingTime,-Z_Bar(:,1)-2.1);
% % plot(SamplingTime, X_EKF(:,3)','k', 'LineWidth', 1.5);grid on;
% hold off;
% grid on;
% % xlim([0 212]);
% xlabel('Sampling time [s]');ylabel('Z [m]')
% legend('GPS trajectory','Triangulation trajectory')%,'EKF estimated trajectory');%,'Barometer reading'