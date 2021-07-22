function w=R2w(R)
% Recibe matriz de giro R. 
% Devuelve vector de giro w (3x1) equivalente.  
  q=[R(3,2)-R(2,3); R(1,3)-R(3,1); R(2,1)-R(1,2)];
  norma = norm(q);
  n=q/norma;
  
  r=(R(1,1)+R(2,2)+R(3,3))-1;
  w=atan2(norma,r);
  w=w*n;
  w=reshape(w,3,1); % Makes sure we return a column vector
return

