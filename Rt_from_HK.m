function [R,t]=Rt_from_HK(H,K)

Q=inv(K)*H;
fprintf('Q = \n');
fprintf('%6.1f %6.1f %7.1f\n',Q');

n1=norm(Q(:,1));
n2=norm(Q(:,2));
l=sqrt(n1*n2);
fprintf('lambda = %f\n',l);

r1=Q(:,1)./l;
r2=Q(:,2)./l;
t=Q(:,3)./l;
fprintf('r1 = \n');
fprintf('%6.1f %6.1f %7.1f\n',r1');
fprintf('r2 = \n');
fprintf('%6.1f %6.1f %7.1f\n',r2');
fprintf('t = \n');
fprintf('%6.1f %6.1f %7.1f\n',t');

r3 = cross(r1,r2);
R=[r1 r2 r3];
[U,S,V]=svd(R);
S=eye(3,3);
R=U*S*V;
fprintf('R = \n');
fprintf('%6.1f %6.1f %7.1f\n',R');

%comprobar R -> I = R'*R
I = R'*R;
fprintf('I = \n');
fprintf('%6.1f %6.1f %7.1f\n',I');
return