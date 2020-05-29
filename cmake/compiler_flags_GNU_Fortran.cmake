# (C) Copyright 2020 UCAR.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.

####################################################################
# FLAGS COMMON TO ALL BUILD TYPES
####################################################################

if( HAVE_OMP )
  set( CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -fopenmp")
else( )
  set( CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -fno-openmp")
endif( )

set( CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -fdec -fdefault-real-8 -fdefault-double-8 -fcray-pointer -fconvert=big-endian -ffree-line-length-none -fno-range-check -fbacktrace")

####################################################################
# RELEASE FLAGS
####################################################################

set( CMAKE_Fortran_FLAGS_RELEASE "-O3 -funroll-all-loops -finline-functions ")

####################################################################
# DEBUG FLAGS
####################################################################

set( CMAKE_Fortran_FLAGS_DEBUG   "-O0 -g -fcheck=bounds -ffpe-trap=invalid,zero,overflow,underflow -fbacktrace" )

####################################################################
# BIT REPRODUCIBLE FLAGS
####################################################################

set( CMAKE_Fortran_FLAGS_BIT     "-O2 -funroll-all-loops -finline-functions" )

####################################################################
# LINK FLAGS
####################################################################

set( CMAKE_Fortran_LINK_FLAGS    "" )

####################################################################
