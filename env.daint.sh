#!/bin/bash

# This script contains functions for setting up machine specific compile
# environments for the dycore and the Fortran parts. Namely, the following
# functions must be defined in this file:

module load daint-gpu
module swap PrgEnv-cray PrgEnv-gnu
module load cray-python
module load cray-mpich
module load Boost
module load cudatoolkit
NVCC_PATH=$(which nvcc)
export CUDA_HOME=$(echo $NVCC_PATH | sed -e "s/\/bin\/nvcc//g")
export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH
export MPICH_RDMA_ENABLED_CUDA=1

# since gridtools does not play nice with gcc 8.3 we switch to 8.1
module switch gcc/8.3.0 gcc/8.1.0

# the eve toolchain requires a clang-format executable, we point it to the right place
export CLANG_FORMAT_EXECUTABLE=/project/s1053/install/venv/vcm_1.0/bin/clang-format
