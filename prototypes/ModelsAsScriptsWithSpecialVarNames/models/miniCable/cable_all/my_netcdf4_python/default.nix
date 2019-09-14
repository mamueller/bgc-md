{ stdenv, buildPythonPackage, fetchPypi, isPyPy, pytest
, numpy, zlib, netcdf, hdf5, curl, libjpeg, cython, cftime 
,mpi4py ? null, openssh ? null}:
assert (mpi4py!= null) -> 
  openssh != null
  && hdf5.mpi == mpi4py.mpi 
  && netcdf.mpi == mpi4py.mpi;

let 
  mpiSupport = (mpi4py!=null);
  mpi= if mpiSupport then mpi4py.mpi else null;
in
  buildPythonPackage rec {
    pname = "netCDF4";
    version = "1.5.1.2";
  
    disabled = isPyPy;
    
    src = fetchPypi {
      inherit pname version;
      sha256 = "161pqb7xc9nj0dlnp6ply8c6zv68y1frq619xqfrpmc9s1932jzk";
    };
  
    checkInputs = [ pytest ];
  
    buildInputs = [
      cython 
      mpi 
    ];
  
    propagatedBuildInputs = [
      cftime
      numpy
      zlib
      netcdf
      hdf5
      curl
      libjpeg
    ] ++ (if mpiSupport then [mpi4py openssh] else []);

    patches=[./parallel4Detection.patch];
  
    preBuild= if mpiSupport then ''
      makeFlagsArray+=( CC=mpicc CXX=mpicxx )
    '' else "";

    checkPhase = ''
      py.test test/tst_*.py
    '';
  
    # Tests need fixing.
    doCheck = false;
  
    # Variables used to configure the build process
    USE_NCCONFIG="0";
    HDF5_DIR="${hdf5}";
    NETCDF4_DIR="${netcdf}";
    CURL_DIR="${curl.dev}";
    JPEG_DIR="${libjpeg.dev}";
    #  test for mpi first and then set
    # MPI_INCDIR="${mpi}/include" ;
    # is not necessary
    
    passthru = {
      mpiSupport = mpiSupport;
      inherit mpi;
    }; 
    meta = with stdenv.lib; {
      description = "Interface to netCDF library (versions 3 and 4) with support for parallel IO";
      homepage = https://pypi.python.org/pypi/netCDF4;
      license = licenses.free;  # Mix of license (all MIT* like)
    };
  }