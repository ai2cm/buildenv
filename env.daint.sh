#!/bin/bash

# This script contains functions for setting up machine specific compile
# environments for the dycore and the Fortran parts. Namely, the following
# functions must be defined in this file:

module load daint-gpu
module swap PrgEnv-cray PrgEnv-gnu
module load cray-python/3.8.2.1
module load cray-mpich/7.7.18
module load Boost/1.78.0-CrayGNU-21.09-python3
module load cudatoolkit/11.2.0_3.39-2.1__gf93aa1c
module load graphviz/2.44.0
module load /project/s1053/install/modulefiles/gcloud/303.0.0
module load cray-hdf5

module switch gcc gcc/9.3.0
module switch cray-python cray-python/3.8.2.1

# load gridtools modules
module load /project/s1053/install/modulefiles/gridtools/2_2_0

NVCC_PATH=$(which nvcc)
export CUDA_HOME=$(echo $NVCC_PATH | sed -e "s/\/bin\/nvcc//g")
export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH

# gt4py files take longer to exist due to distributed filesystem

export GT_CACHE_LOAD_RETRY_DELAY=500  # milliseconds
export GT_CACHE_LOAD_RETRIES=10

# Setup RDMA for GPU. Set PIPE size to 256 (# of messages allowed in flight)
# Turn as-soon-as-possible transfer (NEMESIS_ASYNC_PROGRESS) on
export MPICH_RDMA_ENABLED_CUDA=1
export MPICH_G2G_PIPELINE=256
export MPICH_NEMESIS_ASYNC_PROGRESS=1
export MPICH_MAX_THREAD_SAFETY=multiple

# DO NOT TURN ON
# Cray CUDA MPS virtualizes the memory space of the driver to allow
# for multiple process to access the GPU "efficiently". Unfortunately
# this is done _above_ the driver, therefore as CUDA change their memory
# model it creates issues. Namely `mallocAsync` cannot be used (for memory
# pooling)
# export CRAY_CUDA_MPS=1
# export CRAY_CUDA_PROXY=0


# the eve toolchain requires a clang-format executable, we point it to the right place
export CLANG_FORMAT_EXECUTABLE=/project/s1053/install/venv/vcm_1.0/bin/clang-format

export PYTHONPATH=/project/s1053/install/serialbox/gnu/python:$PYTHONPATH
export WHEEL_DIR=/project/s1053/install/wheeldir

# Since we are loading netcdf files from /project we need this
export HDF5_USE_FILE_LOCKING=FALSE
