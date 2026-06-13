% timestamps from paper notes
clear
tnow = time();
timetemplate = localtime(tnow);

timetemplate.usec = 0;
timetemplate.min = 0;
timetemplate.hour = 0;
timetemplate.mday = 25;
timetemplate.mon = 4;
timetemplate.year = 121;
timetemplate.wday = 2;
timetemplate.yday = 144;
timetemplate.isdst = 1;
timetemplate.gmtoff = 10800;
timetemplate.zone = 'EEST';

t_start_structs = repmat(timetemplate, 1, 4);
t_stop_structs = repmat(timetemplate, 1, 4);  
  
t_start_structs(1).hour = 13;
t_start_structs(1).min = 56;
t_start_structs(1).sec = 0;
t_stop_structs(1).hour = 13;
t_stop_structs(1).min = 57;
t_stop_structs(1).sec = 59;

t_start_structs(2).hour = 13;
t_start_structs(2).min = 57;
t_start_structs(2).sec = 0;
t_stop_structs(2).hour = 13;
t_stop_structs(2).min = 59;
t_stop_structs(2).sec = 59;

t_start_structs(3).hour = 13;
t_start_structs(3).min = 59;
t_start_structs(3).sec = 0;
t_stop_structs(3).hour = 14;
t_stop_structs(3).min = 0;
t_stop_structs(3).sec = 59;

t_start_structs(4).hour = 14;
t_start_structs(4).min = 0;
t_start_structs(4).sec = 0;
t_stop_structs(4).hour = 14;
t_stop_structs(4).min = 3;
t_stop_structs(4).sec = 59;

for k=1:4
  % seconds = mktime(localtime);
  t_start(k) = mktime(t_start_structs(k));
  t_stop(k) = mktime(t_stop_structs(k));
end
 
save -v7 timestamps.mat t_start t_stop