# (C) Copyright 2020 UCAR.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.

# Compiler definitions
# --------------------
add_definitions( -Duse_libMPI -Duse_netCDF -DSPMD -DUSE_LOG_DIAG_FIELD_INFO -Duse_LARGEFILE -DOLDMPP -DGFS_PHYS )

# Special cases
# -------------
if( CMAKE_Fortran_COMPILER_ID MATCHES "GNU" OR CMAKE_Fortran_COMPILER_ID MATCHES "Clang")
  set( CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -ffree-line-length-none -fdec -fno-range-check ")
endif()

# Option to compile dyn core in single or double precision
# --------------------------------------------------------
if (FV3_PRECISION MATCHES "DOUBLE" OR NOT FV3_PRECISION)

  # Add double precision compilation flags
  if( CMAKE_Fortran_COMPILER_ID MATCHES "Clang" )

    set( CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -fdefault-real-8 -fdefault-double-8 ")

  elseif( CMAKE_Fortran_COMPILER_ID MATCHES "Cray" )

    set( CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} --sreal64 ")

  elseif( CMAKE_Fortran_COMPILER_ID MATCHES "GNU" )

    set( CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -fdefault-real-8 -fdefault-double-8 ")

  elseif( CMAKE_Fortran_COMPILER_ID MATCHES "Intel" )

    set( CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -r8")

  elseif( CMAKE_Fortran_COMPILER_ID MATCHES "PGI" )

    set( CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -r8")

  elseif( CMAKE_Fortran_COMPILER_ID MATCHES "XL" )

    set( CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -qdpc")

  else()

    message( FATAL "Fortran compiler with ID ${CMAKE_CXX_COMPILER_ID} does not have double precision flags set")

  endif()

else()

  # Overload definition similar to FMS
  add_definitions( -DOVERLOAD_R4 -DSINGLE_FV )

endif()

# OpenMP
# ------
if( HAVE_OMP )

  if( CMAKE_Fortran_COMPILER_ID MATCHES "Clang" )

    set( CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -fopenmp")

  elseif( CMAKE_Fortran_COMPILER_ID MATCHES "Cray" )

    set( CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -homp")

  elseif( CMAKE_Fortran_COMPILER_ID MATCHES "GNU" )

    set( CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -fopenmp")

  elseif( CMAKE_Fortran_COMPILER_ID MATCHES "Intel" )

    set( CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -qopenmp")

  elseif( CMAKE_Fortran_COMPILER_ID MATCHES "PGI" )

    set( CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -mp")

  elseif( CMAKE_Fortran_COMPILER_ID MATCHES "XL" )

    set( CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -qsmp=omp" )
    set( CMAKE_Fortran_LINK_FLAGS "${CMAKE_Fortran_LINK_FLAGS} -qsmp=omp" )

  else()

    message( STATUS "Fortran compiler with ID ${CMAKE_CXX_COMPILER_ID} will be used with CMake default options")

  endif()

else()

  if( CMAKE_Fortran_COMPILER_ID MATCHES "Clang" )

    set( CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -fno-openmp")

  elseif( CMAKE_Fortran_COMPILER_ID MATCHES "Cray" )

    set( CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -hnoomp")

  elseif( CMAKE_Fortran_COMPILER_ID MATCHES "GNU" )

    set( CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -fno-openmp")

  elseif( CMAKE_Fortran_COMPILER_ID MATCHES "Intel" )

    set( CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -qopenmp-stubs")

  elseif( CMAKE_Fortran_COMPILER_ID MATCHES "PGI" )

    set( CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS}  ")

  elseif( CMAKE_Fortran_COMPILER_ID MATCHES "XL" )

    set( CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -qsmp=noomp" )
    set( CMAKE_Fortran_LINK_FLAGS "${CMAKE_Fortran_LINK_FLAGS} -qsmp=noomp" )

  else()

    message( STATUS "Fortran compiler with ID ${CMAKE_CXX_COMPILER_ID} will be used with CMake default options")

  endif()

endif()
