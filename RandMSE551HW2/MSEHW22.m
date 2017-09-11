count = 0;
clear X;clear Y;
for i = .9:0.05:3
   command_line = ['lmp_serial -var spacing ' num2str(i) ' < in.2atoms']

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
   X(count) = i; Y(count) = totalenergy1;
end
clf
plot(X,Y,'r-*'), axis ([0 4 -1 5])
xlabel('Distance'), ylabel('Total Energy'), title('Energy vs Distance, LJ Potential')