function R=w2R(w) 
% Recibe vector de giro w (3x1). 
% Devuelve matriz de giro R (3x3) equivalente. 
w2=norm(w);
n=w/w2;
N=[0 -n(3) n(2); n(3) 0 -n(1); -n(2) n(1) 0];
N2=n*n';

I=[1 0 0; 0 1 0; 0 0 1];
R=I*cos(w2) + N*sin(w2) + N2*(1-cos(w2));

return

