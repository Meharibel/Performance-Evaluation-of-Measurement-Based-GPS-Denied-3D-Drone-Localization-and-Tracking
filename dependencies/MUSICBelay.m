%   estAmp - estimated amplitudes
function [G] = MUSICBelay(U, elementsLocations, PHI, THETA, lamdaScaleIn)
if nargin > 3
  lamdaScale = lamdaScaleIn;
else
  lamdaScale = 1;
end
c = 299792458 ;
f = 490.0e6;
lamda = c./f;
L = 0.3059; %lamda/2; %0.1529*2; % antenna length, half wavelength antenna
k = 1/((lamda/2)*lamdaScale);
[m,n] = size(PHI);
G = zeros(size(PHI));
nrAnteElem = length(elementsLocations(:,1));
% conversion for t in -pi/2 to pi/2
sph2cartKru = @(p,t,r) [cos(t)*cos(p) cos(t)*sin(p) sin(t)];
% conversion for t in 0 to pi
% sph2cartKru = @(p,t,r) [sin(t)*cos(p) sin(t)*sin(p) cos(t)];
for i1 = 1:m
  for i2 = 1:n
    % norm1 = [sin(THETA(i1,i2))*cos(PHI(i1,i2)) sin(THETA(i1,i2))*sin(PHI(i1,i2)) cos(THETA(i1,i2))];
    estDirection = sph2cartKru(PHI(i1,i2),THETA(i1,i2),1); 
    l1=zeros(nrAnteElem,1);
    for i3 = 1:nrAnteElem
      l1(i3) = dot(elementsLocations(i3,:),estDirection);
    end
    estA = exp(-1i*2*pi*k*L*l1);
    G(i1,i2) =  real(estA'*estA/(estA'*(U*U')*estA));
  end
end
end

% x=50
% y=x.^2
% plot(x,y)
% % title ('graph with x='str'')
% title( ['just an example of ' num2str(x) ' that isnt working'] )
% pause
