count = 0;
clear X;clear Y;
for i = 3.95:0.01:4.15
   command_line = ['lmp_serial -var latconst ' num2str(i) ' < calc_fcc1.in']

   % this next line executes the command line
   system(command_line) 

   % all that is left is to mine the 'log.lammps' file for the energy
   fid = fopen('log.lammps');
        tline = fgetl(fid);
        while ~feof(fid)
           matches = strfind(tline, '%%');
           num = length(matches);
           if num > 0 && matches == 1
                teval = strrep(tline,'%%','');
                eval(teval)
           end
           tline = fgetl(fid);
        end
    fclose(fid);

   % store the values in a matrix
   count = count + 1;
   X(count) = volume; Y(count) = totaleng; 
end
C=[0:200];
Z=(0.0036.*(C.^2)-0.48.*C+2.8);
clf
plot(X,Y,'r-*',C,Z,'b-'), axis ([10 600 -15 5])
xlabel('Volume (A^3)'), ylabel('Total Energy (eV)'), title('Energy vs Volume, EAM Potential'), legend('E vs V', 'Y=0.0036X^2-0.48X+2.8')
