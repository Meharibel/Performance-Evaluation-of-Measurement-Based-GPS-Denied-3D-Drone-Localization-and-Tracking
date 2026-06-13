%example script to handle variables sensor_times, sensor_x, sensor_y, sensor_y
clear
load('2021-05-25_14-04-04_01587_continuous_meas.mat')
% load('2021-05-25_14-34-29_02762_continuous_meas.mat')
load('timestamps.mat')
% indexes of linear flight
[~,idx_linear] = find(times>t_start(3) & times<t_stop(3));
%idx_linear = 1:1:length(meas);
% figure out offset between system clocks
N_meas = length(times);
for k=1:N_meas
  t_tmp = cell2mat(sensor_times(k));
  sensor_duration(k) = t_tmp(end) - t_tmp(1);
  sensor_t_offset(k) = times(k) - t_tmp(1);
end  
avg_offset = median(sensor_t_offset); 
% calculate average position over VNA measurement duration
% note that sensor values are in cell arrays due to different amount of 
% datapoints for each VNA measurement
% timestamps of VNA measurement (times, end_times) should largely overlap with
% sensor timestamps, in case they do not, NaN is recorded for x,y,z instead
for n=1:N_meas
  t_s = cell2mat(sensor_times(n));
  idx = (t_s > times(n)-avg_offset) & (t_s < end_times(n)-avg_offset);
  disp(strcat(['Number of sensor readings at ' num2str(n) ' is ' ...
               num2str(sum(idx))]));
  
  if sum(idx) < 1
    disp('Timestamps mismatched')
    x(n) = NaN;
    y(n) = NaN;
    z(n) = NaN;
  else
    xvals = cell2mat(sensor_x(n));
    x(n) = mean(xvals(idx))
    yvals = cell2mat(sensor_y(n));
    y(n) = mean(yvals(idx));
    zvals = cell2mat(sensor_z(n));
    z(n) = mean(zvals(idx));
  end
end
clear '[xyz]vals'
% flip y-axis
% y = -y;
% plot and manually adjust xy rotation, xyz offsets
figure(1);
clf
plot3(x(idx_linear(1):idx_linear(end)), y(idx_linear(1):idx_linear(end)), z(idx_linear(1):idx_linear(end)), 'o')
xlabel('X (m)')
ylabel('Y (m)')
zlabel('Z (m)')
grid on
hold on
figure(2);
clf
plot(x(idx_linear(1):idx_linear(end)), y(idx_linear(1):idx_linear(end)), 'o')
xlabel('X (m)')
ylabel('Y (m)')
grid on
hold on
figure(3);
clf
plot(1:1:length(idx_linear(1):idx_linear(end)), z(idx_linear(1):idx_linear(end)), 'o')
xlabel('N_meas')
ylabel('Z (m)')
grid on
hold on
%%Aakash
theta =11.5;  % counterclockwise %m3=theta =30.5,17.5,10.4;m7=41,15.5,15.4
rot_mtx = [cosd(theta), -sind(theta), 0; sind(theta), cosd(theta),0;0,0,1];
%add matrix for rotation in x axis (180 degree)
%rot_mtx2 = [1,0, 0; 0,cosd(theta), -sind(theta); 0, sind(theta), cosd(theta)];
%rot_mtx =rot_mtx1*rot_mtx2;
% x = x-6.5;
% y = y+8.4;
rot_mtx1 = [cosd(180),0,sind(180);0,1,0;-sind(180), 0, cosd(180)];
rot_mtx =rot_mtx*rot_mtx1;
xy_rot = rot_mtx * [x',y',z']';

%%Lauri
% % rotation matrix
% theta =28;  % counterclockwise %m3=theta =30.5,17.5,10.4;m7=41,15.5,15.4
% rot_mtx = [cosd(theta), -sind(theta), 0; sind(theta), cosd(theta),0;0,0,1];
% %add matrix for rotation in x axis (180 degree)
% %rot_mtx2 = [1,0, 0; 0,cosd(theta), -sind(theta); 0, sind(theta), cosd(theta)];
% %rot_mtx =rot_mtx1*rot_mtx2;
% xy_rot = rot_mtx * [x',y',z']';

figure(2);
plot(xy_rot(1,(idx_linear(1):idx_linear(end))), xy_rot(2,(idx_linear(1):idx_linear(end))),'o')
% offset x, y and z
xy_rot_off(1,:) = xy_rot(1,idx_linear(1):idx_linear(end))-6.50;%was 38 and 38
xy_rot_off(2,:) = xy_rot(2,idx_linear(1):idx_linear(end)) + 10.4;
z_off = xy_rot(3,idx_linear(1):idx_linear(end));
figure(1);
plot3(xy_rot_off(1,:), xy_rot_off(2,:), z_off, 'x')
legend('original', 'xy-rotation + xyz-offsets')
figure(2);
plot(xy_rot_off(1,:), xy_rot_off(2,:),'x')
legend('original', 'xy-rotation', 'xy-rotation + xyz-offsets')
figure(3);
plot(1:1:length(idx_linear(1):idx_linear(end)), z_off, 'x')
legend('original', 'z-offset')
meas=meas(idx_linear, :, :);
% x=[-xy_rot_off(1,:)' xy_rot_off(2,:)' z_off'];
x=[xy_rot_off(1,:)' xy_rot_off(2,:)' z_off'];
%sig_mea10 = [0.0008;0.0061; 1000000000000.02];R1 = 10^8*diag(sig_mea10);
