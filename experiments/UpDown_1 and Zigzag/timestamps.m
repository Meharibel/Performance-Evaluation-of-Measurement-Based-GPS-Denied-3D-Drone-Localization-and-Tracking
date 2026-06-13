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

t_start_structs = repmat(timetemplate, 1, 22);
t_stop_structs = repmat(timetemplate, 1, 22);  
  
t_start_structs(1).hour = 14;
t_start_structs(1).min = 19;
t_start_structs(1).sec = 28;
t_stop_structs(1).hour = 14;
t_stop_structs(1).min = 21;
t_stop_structs(1).sec = 20;

t_start_structs(2).hour = 14;
t_start_structs(2).min = 21;
t_start_structs(2).sec = 43;
t_stop_structs(2).hour = 14;
t_stop_structs(2).min = 22;
t_stop_structs(2).sec = 50;

t_start_structs(3).hour = 14;
t_start_structs(3).min = 23;
t_start_structs(3).sec = 20;
t_stop_structs(3).hour = 14;
t_stop_structs(3).min = 24;
t_stop_structs(3).sec = 41;

t_start_structs(4).hour = 14;
t_start_structs(4).min = 25;
t_start_structs(4).sec = 12;
t_stop_structs(4).hour = 14;
t_stop_structs(4).min = 26;
t_stop_structs(4).sec = 16;

t_start_structs(5).hour = 14;
t_start_structs(5).min = 26;
t_start_structs(5).sec = 35;
t_stop_structs(5).hour = 14;
t_stop_structs(5).min = 27;
t_stop_structs(5).sec = 44;

t_start_structs(6).hour = 14;
t_start_structs(6).min = 28;
t_start_structs(6).sec = 17;
t_stop_structs(6).hour = 14;
t_stop_structs(6).min = 29;
t_stop_structs(6).sec = 35;

t_start_structs(7).hour = 14;
t_start_structs(7).min = 31;
t_start_structs(7).sec = 26;
t_stop_structs(7).hour = 14;
t_stop_structs(7).min = 32;
t_stop_structs(7).sec = 36;

t_start_structs(8).hour = 14;
t_start_structs(8).min = 33;
t_start_structs(8).sec = 04;
t_stop_structs(8).hour = 14;
t_stop_structs(8).min = 33;
t_stop_structs(8).sec = 44;

for k=1:8
  % seconds = mktime(localtime);
  t_start(k) = mktime(t_start_structs(k));
  t_stop(k) = mktime(t_stop_structs(k));
end
 
save -v7 timestamps.mat t_start t_stop