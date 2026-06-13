clear

load('timestamps.mat')

% figure out index ranges limited by t_start and t_stop for each measurement
% period 
for k=1:4
  load('2021-05-25_14-04-04_01587_continuous_meas.mat')
  idx = (times > t_start(k)) & (times < t_stop(k));
  disp(sum(idx))
  meas = meas(idx, :, :);
  meas_ids = meas_ids(idx, :);
  sensor_times = sensor_times(1, idx);
  sensor_x = sensor_x(1, idx);
  sensor_y = sensor_y(1, idx);
  sensor_z = sensor_z(1, idx);
  times = times(1, idx);
  end_times = end_times(1, idx);
  fname = strcat('period', num2str(k), '.mat');
  save('-v7', fname, 'meas', 'meas_ids', 'sensor_times', 'sensor_x', ...
        'sensor_y', 'sensor_z', 'times', 'end_times', 'tracename', 'f'); 
end

