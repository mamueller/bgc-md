#!/bin/bash
set -e
#PBS -l ncpus=10
#PBS -l mem=5gB
#PBS -l walltime=48:00:00
#module rm netcdf
#module add netcdf/4.2.1.1 openmpi/1.8.8
#mm: commented out 
#cd /short/p66/czl599/CABLE-run-test-lqy/spinup
cd ../spinup
./mknml_mm.bash
#cp -p /home/599/czl599/workdir/code/CABLE2.0_mpi_yp1220/offline/cable-mpi ./

i=1
echo copy pool file
#cp -p /short/p66/czl599/CABLE-run-test-lqy/spinup/output/new3/poolcnp_out_1910_ndep.csv ./poolcnp_in.csv
# mm: I cant find this file My\ Passport/cable_chris_transit_time/CABLE-run-test-lqy/spinup/does not have a output folder
# assuming My\ Passport/cable_chris_transit_time/CABLE-run-test-lqy/spinup/poolcnp_in.csv
# which is linked
cp -p ../../CABLE-run-test-lqy/spinup/poolcnp_in.csv ./poolcnp_in.csv

echo copy restart file
#cp -p /short/p66/czl599/CABLE-run-test-lqy/spinup/output/new3/restart_ncar_1910_ndep.nc ./restart_in.nc
# mm: I cant find this file My\ Passport/cable_chris_transit_time/CABLE-run-test-lqy/spinup/does not have a output folder
# assuming My\ Passport/cable_chris_transit_time/CABLE-run-test-lqy/spinup/restart_in.nc
# which is now linked to ../../CABLE-run-test-lqy/spinup/restart_in.nc
cp -p  ../../CABLE-run-test-lqy/spinup/restart_in.nc ./restart_in.nc


#prepare directory
odir="output/new4"
mkdir -p ${odir}


while [ $i -le 5 ]
do
yr=1901
  while [ $yr -le 1910 ]
  do
    #mm the files are now produced here
    #cp -p /home/599/czl599/nml/cable_C_spinup_${yr}.nml cable.nml
    cp -p cable_CN_spindump_${yr}.nml cable.nml #for the paper only CN
    # mm: I cant find this file:
    # assuming My\ Passport/cable_chris_transit_time/
    mpirun -np 9 --oversubscribe ../../CABLE-SRC/offline/tmpParallel/cable-mpi
    mv out_cable.nc      ${odir}/out_ncar_${i}_${yr}_ndep.nc
    mv log_cable.txt     ${odir}/log_ncar_${yr}_ndep.txt
    cp -p restart_out.nc restart_in.nc
    cp -p poolcnp_out.csv poolcnp_in.csv
    mv cnpflux${yr}.csv  ${odir}/cnpfluxndep_${yr}_ndep.csv
    mv restart_out.nc    ${odir}/restart_ncar_${i}_${yr}_ndep.nc
    mv poolcnp_out.csv   ${odir}/poolcnp_out_${i}_${yr}_ndep.csv
    if [ $i -eq 5 ];then
      cp -p cnpspindump${yr}.nc ${odir}/
    fi
    yr=`expr $yr + 1`
  done
  i=`expr $i + 1`
done
echo "######################################################################################################"
echo "after first loop"
echo "######################################################################################################"
cat <<EOF >fcnpspin.lst
10
${odir}/cnpspindump1901.nc
${odir}/cnpspindump1902.nc
${odir}/cnpspindump1903.nc
${odir}/cnpspindump1904.nc
${odir}/cnpspindump1905.nc
${odir}/cnpspindump1906.nc
${odir}/cnpspindump1907.nc
${odir}/cnpspindump1908.nc
${odir}/cnpspindump1909.nc
${odir}/cnpspindump1910.nc
EOF

cp -p cable_CN_spincasa_${yr}.nml cable.nml
mpirun -np 9 --oversubscribe ../../CABLE-SRC/offline/tmpParallel/cable-mpi
mv out_cable.nc     ${odir}/out_ncar_${i}_0_ndep.nc
cp -p restart_out.nc restart_in.nc
cp -p poolcnp_out.csv poolcnp_in.csv
mv restart_out.nc ${odir}/restart_ncar_${yr}_ndep.nc
mv poolcnp_out.csv ${odir}/poolcnp_out_${yr}_ndep.csv


while [ $i -le 10 ]
do
yr=1901
  while [ $yr -le 1910 ]
  do
    #mm the files are now produced here
    #cp -p /home/599/czl599/nml/cable_C_spinup_${yr}.nml cable.nml
    cp -p cable_CN_spiupdump_${yr}.nml cable.nml #for the paper only CN
    # mm: I cant find this file:
    # assuming My\ Passport/cable_chris_transit_time/
    mpirun -np 9 --oversubscribe ../../CABLE-SRC/offline/tmpParallel/cable-mpi
    mv out_cable.nc      ${odir}/out_ncar_${i}_${yr}_ndep.nc
    mv log_cable.txt     ${odir}/log_ncar_${yr}_ndep.txt
    cp -p restart_out.nc restart_in.nc
    cp -p poolcnp_out.csv poolcnp_in.csv
    mv cnpflux${yr}.csv  ${odir}/cnpfluxndep_${yr}_ndep.csv
    mv restart_out.nc    ${odir}/restart_ncar_${i}_${yr}_ndep.nc
    mv poolcnp_out.csv   ${odir}/poolcnp_out_${i}_${yr}_ndep.csv
    if [ $i -eq 10 ];then
      cp -p cnpspindump${yr}.nc ${odir}/
    fi
    yr=`expr $yr + 1`
  done
  i=`expr $i + 1`
done
echo "######################################################################################################"
echo "after second loop"
echo "######################################################################################################"