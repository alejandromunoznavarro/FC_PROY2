global aux
im=imread('malla1.jpg'); 

figure(1); imshow(im)

% Calcular imagen auxiliar aux a partir de im 
aux=rgb2gray(im); %aux=min(im,[],3);
gg = fspecial('gaussian',15,5); aux=imfilter(aux,gg);
imshow(aux);
lista={'superior izda ','superior drcha','inferior drcha','inferior izda '};
u=zeros(4,1); v=zeros(4,1);  % Reserva para guardar coordenadas esquinas

X=[-10;10;10;-10];
Y=[6;6;-6;-6];
% 
%  for k=1:4,  
%   fprintf('Pincha esquina %s:',lista{k});  
%   [x,y]=ginput(1); 
%   fprintf('x=%6.1f,y=%6.1f\n',x,y);
%   
%   hold on; plot(x,y,'ro','MarkerFaceCol','r','MarkerSize',3); hold off
%   [x,y] = refinar(x,y);
%   u(k) = x;
%   v(k) = y;
%   fprintf('u=%6.1f,v=%6.1f\n',u(k),v(k));
%    hold on; plot(u(k),v(k),'go','MarkerFaceCol','g','MarkerSize',3); hold off
%  end
% hold on; plot([u;u(1)],[v;v(1)],'b'); hold off;
% 
%  H=fc_get_H([X Y],[u v]);
%  fprintf('%6.1f %6.1f %7.1f\n',H');
% save H H;

%2. Estimacion de H con Todos los puntos de la malla
load H;

load malla_XY;
hold on; plot(X,Y,'bo'); hold off;

%   Calculamos coordenadas
C=[X Y X.^0]*H';
u=C(:,1)./C(:,3);
v=C(:,2)./C(:,3);

%   Refinamos todos los puntos
for k=1:77
     hold on; plot(u(k),v(k),'ro','MarkerFaceCol','r','MarkerSize',3); hold off
    [u(k),v(k)] = refinar(u(k),v(k));
    hold on; plot(u(k),v(k),'go','MarkerFaceCol','g','MarkerSize',3); hold off
end

H=fc_get_H([X Y],[u v]);
fprintf('%6.1f %6.1f %7.1f\n',H');

h1 = H(:,1);
h2 = H(:,2);

tam=size(aux);

u0=tam(1)/2;
v0=tam(2)/2;
B0=[1 0 -u0; 0 1 -v0; -u0 -v0 (u0^2)+(v0^2)];

f=sqrt(-(h1'*B0*h2)/(H(3,1)*H(3,2)));
fprintf('f= %f \n',f);

densidad=tam(1)/23.7;
fprintf('densidad= %f \n',densidad);
f=f/densidad;
fprintf('f(mm)= %f \n',f);

% 4. Estimación de la posición/pose de la cámara
K=[f 0 u0 ; 0 f v0 ; 0 0 1];
[R,t]=Rt_from_HK(H,K);
X0=-R'*t;
fprintf('X0 = \n');
fprintf('%6.1f %6.1f %7.1f\n',X0');

% 5. Mejora de las estimaciones usando optimización
% w=[0.6000; -0.7000; 0.4500];
% fprintf('%f\n',w');
% R=w2R(w);
% fprintf('w2R = \n');
% fprintf('%f %f %f\n',R');
% w=R2w(R);
% fprintf('R2w = \n');
% fprintf('%f %f %f\n',w');

% R=[0.3481 0.9332 0.0893; 0.6313 -0.3038 0.7135; 0.6930 -0.1920 -0.6949];
% w=R2w(R);
% fprintf('R2w = \n');
% fprintf('%f %f %f\n',w');
% w=[1 2 3]';
% R=w2R(w);
% fprintf('w2R = \n');
% fprintf('%f %f %f\n',R');

% Se añade k1 para el punto 6
k1=0;
w=R2w(R);
P0=[w;t;f;k1];
fprintf('f=%f\n',f');
e=error_uv(P0,X,Y,u,v);
figure();
hold on;plot(e);hold off;
n=norm(e);
fprintf('norma=%f\n',n);

opts=optimset('Algorithm','levenberg-marquardt','Display','off');
f_min=@(P)error_uv(P,X,Y,u,v);
P=lsqnonlin(f_min,P0,[],[],opts);
f=P(7);
fprintf('f=%f\n',f);

w=P(1:3);
t=P(4:6);
fprintf('w=%f %f %f\n',w');
fprintf('t=%f %f %f\n',t');
e=error_uv(P,X,Y,u,v);
hold on;plot(e);hold off;
n=norm(e);
fprintf('norma=%f\n',n);
