# (C) Copyright 2020 UCAR.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.

####################################################################################################
# FV3
####################################################################################################

cmake_minimum_required( VERSION 3.3.2 FATAL_ERROR )

project( fv3 VERSION 1.1.0 LANGUAGES C CXX Fortran )

set( CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake;${CMAKE_MODULE_PATH} )

set( CMAKE_DIRECTORY_LABELS "fv3" )

set( ECBUILD_DEFAULT_BUILD_TYPE Release )
set( ENABLE_OS_TESTS           OFF CACHE BOOL "Disable OS tests" FORCE )
set( ENABLE_LARGE_FILE_SUPPORT OFF CACHE BOOL "Disable testing of large file support" FORCE )

include( ecbuild_system NO_POLICY_SCOPE )

ecbuild_requires_macro_version( 2.7 )

####################################################################################################
# Project
####################################################################################################

ecbuild_declare_project()

ecbuild_enable_fortran( REQUIRED )

set( FV3_LINKER_LANGUAGE Fortran )

####################################################################################################
# Dependencies
####################################################################################################

#openMP
ecbuild_enable_omp()

# jedi-cmake
find_package( jedicmake QUIET )

# NetCDF
find_package( NetCDF REQUIRED COMPONENTS Fortran )

# MPI
ecbuild_find_mpi( COMPONENTS CXX Fortran REQUIRED )

# FMS
find_package( fms REQUIRED )

####################################################################################################
# Export package info
####################################################################################################

list( APPEND FV3_TPLS NetCDF fms )

set( FV3_INCLUDE_DIRS ${CMAKE_Fortran_MODULE_DIRECTORY} )
set( FV3_LIBRARIES fv3 )

get_directory_property( FV3_DEFINITIONS COMPILE_DEFINITIONS )

foreach( _tpl ${FV3_TPLS} )
  string( TOUPPER ${_tpl} TPL )
  list( APPEND FV3_EXTRA_DEFINITIONS   ${${TPL}_DEFINITIONS}  ${${TPL}_TPL_DEFINITIONS}  )
  list( APPEND FV3_EXTRA_INCLUDE_DIRS  ${${TPL}_INCLUDE_DIRS} ${${TPL}_TPL_INCLUDE_DIRS} )
  list( APPEND FV3_EXTRA_LIBRARIES     ${${TPL}_LIBRARIES}    ${${TPL}_TPL_LIBRARIES}    )
endforeach()

####################################################################################################
# Sources
####################################################################################################

include( fv3_compiler_flags )
include_directories( ${FV3_INCLUDE_DIRS} ${FV3_EXTRA_INCLUDE_DIRS} )

list( APPEND fv3_src_files
  model/a2b_edge.F90
  model/boundary.F90
  model/dyn_core.F90
  model/fv_arrays.F90
  model/fv_cmp.F90
  model/fv_control.F90
  model/fv_dynamics.F90
  model/fv_fill.F90
  model/fv_grid_utils.F90
  model/fv_mapz.F90
  model/fv_nesting.F90
  model/fv_regional_bc.F90
  model/fv_sg.F90
  model/fv_tracer2d.F90
  model/fv_update_phys.F90
  model/gfdl_cloud_microphys.F90
  model/module_mp_radar.F90
  model/multi_gases.F90
  model/nh_core.F90
  model/nh_utils.F90
  model/sw_core.F90
  model/tp_core.F90
  tools/external_ic.F90
  #tools/external_ic.F90_65lyrs
  #tools/external_ic.F90_NAM_lyrs
  tools/external_sst.F90
  tools/fv_diagnostics.F90
  tools/fv_eta.F90
  #tools/fv_eta.F90_65lyrs
  #tools/fv_eta.F90_NAM_lyrs
  tools/fv_grid_tools.F90
  #tools/fv_iau_mod.F90
  tools/fv_io.F90
  tools/fv_mp_mod.F90
  tools/fv_nudge.F90
  tools/fv_restart.F90
  tools/fv_surf_map.F90
  tools/fv_timing.F90
  tools/fv_treat_da_inc.F90
  tools/init_hydro.F90
  tools/sim_nc_mod.F90
  tools/sorted_index.F90
  tools/test_cases.F90
)

####################################################################################################
# Add library
####################################################################################################

ecbuild_add_library( TARGET          fv3
                     SOURCES         ${fv3_src_files}
                     PUBLIC_LIBS     fms ${NETCDF_LIBRARIES} MPI::MPI_Fortran
                     PRIVATE_INCLUDES ${PROJECT_SOURCE_DIR}
                     INSTALL_HEADERS LISTED
                     LINKER_LANGUAGE ${FV3_LINKER_LANGUAGE}
                   )

#GFortran-10 support
if(CMAKE_Fortran_COMPILER_ID MATCHES GNU AND CMAKE_Fortran_COMPILER_VERSION VERSION_GREATER_EQUAL 10)
  target_compile_options(fv3 PRIVATE -fallow-argument-mismatch -fallow-invalid-boz)
endif()

####################################################################################################
# Install the Fortran modules
####################################################################################################

if(ECBUILD_INSTALL_FORTRAN_MODULES)
	install(DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY}/${CMAKE_CFG_INTDIR} DESTINATION ${CMAKE_INSTALL_INCLUDEDIR} )
endif()

target_include_directories( fv3 INTERFACE $<BUILD_INTERFACE:${CMAKE_Fortran_MODULE_DIRECTORY}>
                                          $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>)

####################################################################################################
# Finalise configuration
####################################################################################################

# prepares a tar.gz of the sources and/or binaries
ecbuild_install_project( NAME fv3 )

# print the summary of the configuration
ecbuild_print_summary()
