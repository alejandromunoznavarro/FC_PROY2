function e=error_uv(P,X,Y,u,v)
global aux
tam=size(aux);
u0=tam(1)/2;
v0=tam(2)/2;
%   Reservar uu y vv del mismo tamaño que u y v
uu=zeros(77,1);
vv=zeros(77,1);
%   Extraer parametros del vector P
w=P(1:3);
t=P(4:6);
f=P(7);
%   Convertir w en R y extraer Q
R=w2R(w);
Q=[R(:,1) R(:,2) t];
%   Aplicar Q a coordenadas [X Y 1]
C=[X Y X.^0]*Q';
%   Pasar a coordenadas normalizadas
x=C(:,1)./C(:,3);
y=C(:,2)./C(:,3);

%   Para el punto 6
% k1=P(8);
% r=x.^2 + y.^2;
% x=x.*(1+k1*r);
% y=y.*(1+k1*r);

%   Usar la focal f para pasar de coordenadas normalizadas a pixeles
%   (uu,vv)
%   Restar para errores entre los pixeles
for k=1:77
    uu(k)=u0+f*x(k);
    vv(k)=v0+f*y(k);
    uu(k)=uu(k)-u(k);
    vv(k)=vv(k)-v(k);
end
e=[uu vv];

return