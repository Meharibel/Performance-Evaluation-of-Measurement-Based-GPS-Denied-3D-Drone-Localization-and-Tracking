
% load Test_Baro_28.mat% contains--sensor_xyz_plotLauri and EKF_Triangu21
% sensor_xyz_plotLauri
N_Measurement
n=a;
% GP=x;
% state matrix
X = zeros(6,1);X1 = zeros(6,1);X2 = zeros(6,1);SamplingTime=0.5:0.5:a/2;
% covariance matrix
P = zeros(6,6);
% kalman filter output through the whole time
X_EKF = zeros(n, 6);
% system noise
% Q = [10.10,0,0,0,0,0;0,10000, 0, 0, 0, 0;0,0,0.01,0,0,0;0,0,0,1,0,0;0,0,0,0,1,0;0,0,0,0,0,10.0061];%UD--First Measurement from 2021-05-25--Continuous2
Q = [10.10,0,0,0,0,0;0,10000, 0, 0, 0, 0;0,0,0.01,0,0,0;0,0,0,1,0,0;0,0,0,0,1,0;0,0,0,0,0,10.0061];
% transition matrix
F = [eye(3), eye(3)*0.5; zeros(3), eye(3)];
% observation matrix 
% load Z_Bar.mat
% R1_b=100.02;R1_b=10^3*R1_b;
% variance of signal1 
%UD--First Measurement from 2021-05-25--Continuous2
% sig_mea1 = [1.948;1000.080000800000061; 12.8102];R1 = 10^5*diag(sig_mea1);
% sig_mea1 = [1.948;1.080000800000061; 1200.8102];R1 = 10^5*diag(sig_mea1);%Zigzag-2

sig_mea1 = [1.948;1.080000800000061; 1200.8102];R1 = 10^5*diag(sig_mea1);
% for jj=1:length(X_min)
for i = 1:n
x_Inter=X_1;
if (i == 1)
[X, P] = init_kalman(X, GP(1,:)); % initialize the state using the 1st sensor
else 
[X, P] = prediction(X, P, Q, F);
[X, P] = update(X, P, x_Inter(i,:), R1);%,j in both
% [X, P] = update2(X, P,  -Z_Bar(i,:)-2.1, R1_b);%,j in both
end
X_EKF( i,:) = X;% iteration of the state in EKF for fused
[Azimuth_EKF(i),Elevation_EKF(i),Range_EKF(i)] = cart2sph(X_EKF(i,1),X_EKF(i,2),X_EKF(i,3));
end
for ii=1:length(GP( :,1))
[Azimuth_Tr(ii),Elevation_Tr(ii),Range_Tr(ii)] = cart2sph(X_1(ii,1),X_1(ii,2),X_1(ii,3));
% Reference1(ii) =atan2((GP(ii,2)),GP(ii,1)+13);
% Reference2(ii)=atan((GP(ii,3))/(sqrt((GP(ii,1)+13).^2 + GP(ii,2).^2)));
[Azimuth_GP(ii),Elevation_GP(ii),Range_GP(ii)] = cart2sph(GP(ii,1),GP(ii,2),GP(ii,3));
[Reference1(ii),Reference2(ii),Reference3(ii)] = cart2sph(GP(ii,1)+13,GP(ii,2),GP(ii,3));

end 
figure(1)
% subplot(3,1,1)
plot(SamplingTime, GP(:,1), 'LineWidth', 1.5);grid on;
hold on;
plot(SamplingTime, x_Inter(:,1), '--', 'LineWidth', 1.5);grid on;
plot(SamplingTime, X_EKF(:,1)','k', 'LineWidth', 1.5);grid on;
hold off;
grid on;
xlim([0 a/2]);%ylim([-25 20])
xlabel('Sampling time [s]');ylabel('X [m]')
legend('GPS trajectory', 'Triangulation trajectory','EKF estimated trajectory');
figure(2)
% subplot(3,1,2)
plot(SamplingTime, GP(:,2), 'LineWidth', 1.5);grid on;
hold on;
plot(SamplingTime, x_Inter(:,2), '--', 'LineWidth', 1.5);grid on;
plot(SamplingTime, X_EKF(:,2)','k', 'LineWidth', 1.5);grid on;
xlim([0 a/2]);
hold off;
grid on;
xlabel('Sampling time [s]');ylabel('Y [m]')
legend('GPS trajectory', 'Triangulation trajectory','EKF estimated trajectory');% figure(3)
figure(3)
% subplot(3,1,3)27
plot(SamplingTime,GP(:,3), 'LineWidth', 1.5);grid on;
hold on;
plot(SamplingTime, x_Inter(:,3), '--', 'LineWidth', 1.5);grid on;
% plot(SamplingTime,-Z_Bar(:,1)-2.1);
plot(SamplingTime, X_EKF(:,3)','k', 'LineWidth', 1.5);grid on;
hold off;
grid on;
xlim([0 a/2]);
xlabel('Sampling time [s]');ylabel('Z [m]')
legend('GPS trajectory','Triangulation trajectory','Barometer reading','EKF estimated trajectory');%,
figure(5)
subplot(3,1,1)
mu=mean(GP(:,1)-X_EKF(:,1));sigma=1;%mean=0,deviation=1
L=a/2; %length of the random vector
R = GP(:,1)-X_EKF(:,1);%method 1
histogram(R,[-15:0.15:15],'Normalization','pdf'); %plot estimated pdf from the generated data
X_PDF = -15:0.1:15; %range of x to compute the theoretical pdf
fx_theory = pdf('Normal',X_PDF,mu,sigma); %theoretical normal probability density
hold on; plot(X_PDF,fx_theory,'r');grid on; %plot computed theoretical PDF
xlabel('X [m]');ylabel('pdf')
subplot(3,1,2);
mu=mean(GP(:,2)-X_EKF(:,2));sigma=1;%mean=0,deviation=1
L=a/2; %length of the random vector
R = GP(:,2)-X_EKF(:,2);%method 1
histogram(R,[-15:0.15:15],'Normalization','pdf'); %plot estimated pdf from the generated data
X_PDF = -15:0.1:15; %range of x to compute the theoretical pdf
fx_theory = pdf('Normal',X_PDF,mu,sigma); %theoretical normal probability density
hold on; plot(X_PDF,fx_theory,'r'); grid on;%plot computed theoretical PDF
xlabel('Y [m]');ylabel('pdf')
subplot(3,1,3);
mu=mean(GP(:,3)-X_EKF(:,3));sigma=1;%mean=0,deviation=1
L=a/2; %length of the random vector
R = GP(:,3)-X_EKF(:,3);%method 1
histogram(R,[-15:0.15:15],'Normalization','pdf'); %plot estimated pdf from the generated data
X_PDF = -15:0.1:15; %range of x to compute the theoretical pdf
fx_theory = normpdf(X_PDF,mu,sigma); %theoretical normal probability density
hold on; plot(X_PDF,fx_theory,'r');grid on; %plot computed theoretical PDF
xlabel('Z [m]');ylabel('pdf')
figure(6)
% % subplot(3,1,1)
plot(SamplingTime, Azimuth_GP*57.3, 'LineWidth', 1.5);grid on;
hold on;
plot(SamplingTime, Azimuth_Tr*57.3, '--', 'LineWidth', 1.5);grid on;
hold on 
plot(SamplingTime, Azimuth_EKF*57.3, ':', 'LineWidth', 1.5);grid on;
hold on 
plot(SamplingTime,Reference1*57.3,'g', 'LineWidth', 1.5);
xlim([0 a/2]);
hold off;
xlabel('Sampling time [s]');ylabel('Azimuth [{\circ} ]')
% legend('GPS value', 'Triangulation','EKF estimated value');
legend('GPS Reference1', 'Triangulation','EKF estimated value','GPS Reference2');

figure(7)
% % subplot(3,1,2)
plot(SamplingTime, Elevation_GP*57.3, 'LineWidth', 1.5);grid on;
hold on;
plot(SamplingTime, Elevation_Tr*57.3, '--', 'LineWidth', 1.5);grid on;
hold on 
plot(SamplingTime, Elevation_EKF*57.3, ':', 'LineWidth', 1.5);grid on;
hold on
plot(SamplingTime,Reference2*57.3, 'g', 'LineWidth', 1.5);grid on;
xlim([0 a/2]);
hold off;
xlabel('Sampling time [s]');ylabel('Elevation [{\circ} ]')
legend('GPS Reference1', 'Triangulation','EKF estimated value','GPS Reference2');
figure(8)
% subplot(3,1,3)
plot(SamplingTime,Range_GP, 'LineWidth', 1.5);grid on;
hold on;
plot(SamplingTime, Range_Tr, '--', 'LineWidth', 1.5);grid on;
hold on
plot(SamplingTime, Range_EKF,'k', 'LineWidth', 1.5);grid on;
% hold on
plot(SamplingTime,Reference3, 'g', 'LineWidth', 1.5);grid on;
xlim([0 a/2]);
hold off
xlabel('Sampling time [s]');ylabel('Range [m]')
legend('GPS trajectory', 'Triangulation trajectory','EKF Estimated trajectory');

%%%%%%%%%%%%%%%%% EKF
function [X, P] = init_kalman(X, y)%initializing the fused
X(1,1) = y(1,1);X(2,1) =y(1,2);X(3,1) = y(1,3)+1;% y(1,2);
Cov_fused_xyz = [0.0086;1.08008001; 1.001];Cov_fused_v = [100000.086;1.808008001; 8.0];
P=[diag(Cov_fused_xyz), zeros(3); zeros(3),80*diag(Cov_fused_v)];
end

function [X, P] = prediction(X, P, Q, F)%Prediction step of the EKF
X = F*X;
P = F*P*F' + Q;
end
function [X, P] = update(X, P, y, R)% Update step of the EKF usig array 2,
pp = X(1:3);  %predict the sates at the height of the array from the ground 
H=eye(3,6);
Inn = y' - pp;%PP;measurement error
S = H*P*H' + R;
K = P*H'/S;
X = X + K*Inn;
P = P - K*H*P;
end
% function [X, P] = update2(X, P, y, R)% Update step of the EKF usig array 2,
% pp = X(3,1);  %predict the sates at the height of the array from the ground 
% % H=eye(1,6);
% H=[0     0     1     0     0     0];
% Inn = y' - pp;%PP;measurement error
% S = H*P*H' + R;
% K = P*H'/S;
% X = X + K*Inn;
% P = P - K*H*P;
% end
