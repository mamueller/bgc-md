echo "hello Markus"
export NAME="simple_xy_par_wr"
export FC="mpif90"
export CC="mpicc"
export NCDIR="${my_netcdf_fortran}/lib"
export NCMOD="${my_netcdf_fortran}/include" 
export CFLAGS="-x f95-cpp-input" 
export LD="-lnetcdff" 
export LDFLAGS="-L ${my_netcdf_fortran}/libs -O2" 
