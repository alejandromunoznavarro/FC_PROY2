function [x,y]=refinar(x,y)
global aux

% Definición del tamaño y coordenadas de la zona a explorar
RAD=40; rg=(-RAD:RAD); dx=ones(2*RAD+1,1)*rg; dy=dx';

x=round(x);
y=round(y);

s=double(aux(rg+y,rg+x,:));
m=min(s(:));
w=exp(-(s-m).^2);
w=w./sum(w(:));
subx=x+dx;
subx=subx.*w;
x = sum(subx(:));
suby=y+dy;
suby=suby.*w;
y = sum(suby(:));

return