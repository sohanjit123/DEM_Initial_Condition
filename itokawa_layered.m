clc,clear all
close all
% load itokawa2.txt
d = importdata('itokawa2.txt');

F=25350;

xi = d(1:F,2);
yi = d(1:F,3);
zi = d(1:F,4);

 fx=(1000).*xi;
fy=(1000).*yi;
fz=(1000).*zi;
  plot3(fx,fy,fz,'r.')
  hold on

fileID = fopen('itolayer.txt','w');

den = 1900;
rad = 20;

K = 1;
N = 1000;

fprintf(fileID,'LAMMPS \n');
% fprintf(fileID,'\n%i ',length(xi)+N+1);
fprintf(fileID,'\n%i ',ceil(F/K)+1928);
fprintf(fileID,'atoms\n');
fprintf(fileID,'2 atom types\n');
fprintf(fileID,'-1000 1000 xlo xhi\n');
fprintf(fileID,'-1000 1000 ylo yhi\n');
fprintf(fileID,'-1000 1000 zlo zhi\n');
fprintf(fileID,'\nAtoms\n\n');


% figure
for i = 1:K:length(xi)
  fprintf(fileID,'%i %i %.4f %.4f %.4f %.4f %.4f %.4f \n',ceil(i/K),1,fx(i),fy(i),fz(i),0,rad,den);
end

p_r = 2;

d_p = 1900;

sc = 1.5;

nfx=sc*fx;nfy=sc*fy;nfz=sc*fz;

o=zeros(F,1);

count=0;
np=0;

for k = 1 : length(xi)
   o(k)=0;
   for t = 1 :length(xi)
       if (k ~= t)
          d = sqrt((nfx(k) - nfx(t))^2 + (nfy(k) - nfy(t))^2+(nfz(k) - nfz(t))^2);
        if(d <=2* p_r)            
             o(k)=o(k)+1;
        end
       end
   end
   
   if(o(k)==0)
       count=count+1;
        if(mod(count,10)==0)
            np=np+1;
      fprintf(fileID,'%i %i %.4f %.4f %.4f %.4f %.4f %.4f \n',ceil(i/K)+np,2,nfx(k),nfy(k),nfz(k),0,p_r,d_p);
      scatter3(nfx(k),nfy(k),nfz(k),'k.')
       hold on
        end
       
   end
      
end







fclose(fileID);
