clc,clear all
% load itokawa2.txt
d = importdata('itokawa2.txt');
 F = 25350;
% F = 99846;
xi = d(1:F,2);
yi = d(1:F,3);
zi = d(1:F,4);

sc = 1000;

 fx=(sc).*xi;
fy=(sc).*yi;
fz=(sc).*zi;
 plot3(fx,fy,fz,'.')

fileID = fopen('input_withcharge.txt','w');

den = 1900;
rad = 20;


K = 1;
N = 999;

fprintf(fileID,'LAMMPS read \n');
fprintf(fileID,'\n%i ',ceil(F/K)+N+1);
fprintf(fileID,'atoms\n');
fprintf(fileID,'6 atom types\n');
fprintf(fileID,'-1000 1000 xlo xhi\n');
fprintf(fileID,'-1000 1000 ylo yhi\n');
fprintf(fileID,'-1000 1000 zlo zhi\n');
fprintf(fileID,'\nAtoms\n\n');

 hold on
% figure
for i = 1:K:length(xi)
  
fprintf(fileID,'%i %i %.4f %.4f %.4f %.4f %.4f %.4f \n',ceil(i/K),1,fx(i),fy(i),fz(i),0,rad,den);
end


rmin = 200;
rmax= 600;h= 700;


count = 0;
p_r = 5;

d_p = 1900;
m=(4/3)*pi*((p_r/2)^3)*d_p;
% G=6.67e-11;
G=1;
C=8.987e9;
q=sqrt(G/C)*m;
q1=sqrt(G/C)*(4/3)*pi*((1/2)^3)*d_p;
q2=sqrt(G/C)*(4/3)*pi*((2/2)^3)*d_p;
q3=sqrt(G/C)*(4/3)*pi*((3/2)^3)*d_p;
q4=sqrt(G/C)*(4/3)*pi*((4/2)^3)*d_p;

% o=0;

while count<=N
 count = count+1;
x(count) = 2*rand*h-h;
z(count) = 2*rmax*rand-rmax;
y(count) = 2*rmax*rand-rmax;
r(count) = sqrt(y(count)^2+z(count)^2);


if r(count)<rmin|r(count)>rmax
    count = count - 1;
     continue;
end

o=0;

    for k = (count-1):-1:1
        d = sqrt((x(count) - x(k))^2 + (y(count) - y(k))^2+(z(count) - z(k))^2);
        if(d<=2*p_r)            
            o=o+1;
         end
        
    end
    
if(o==0) 
       
    if(mod(count,5)==0)
        fprintf(fileID,'%i %i %.4f %.4f %.4f %.4f %.4f %.4f \n',ceil(i/K)+count,2,x(count),y(count),z(count),q1,1,d_p);
    elseif(mod(count,5)==1)
         fprintf(fileID,'%i %i %.4f %.4f %.4f %.4f %.4f %.4f \n',ceil(i/K)+count,3,x(count),y(count),z(count),q2,2,d_p);
    elseif(mod(count,5)==2)
         fprintf(fileID,'%i %i %.4f %.4f %.4f %.4f %.4f %.4f \n',ceil(i/K)+count,4,x(count),y(count),z(count),q3,3,d_p);
    elseif(mod(count,5)==3)
         fprintf(fileID,'%i %i %.4f %.4f %.4f %.4f %.4f %.4f \n',ceil(i/K)+count,5,x(count),y(count),z(count),q4,4,d_p);
    else
        fprintf(fileID,'%i %i %.4f %.4f %.4f %.4f %.4f %.4f \n',ceil(i/K)+count,6,x(count),y(count),z(count),q,5,d_p);
    end
        
else
    count=count-1;
end


end

% Calculation of intial speed
    
   scatter3(x,y,z,10,'filled')
fclose(fileID);
