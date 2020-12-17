#!/bin/bash

# This script contains functions for setting up machine specific compile
# environments for the dycore and the Fortran parts. Namely, the following
# functions must be defined in this file:

module swap PrgEnv-cray PrgEnv-gnu
module load daint-gpu
module load cray-python
module load cray-mpich
module load Boost
module load cudatoolkit
NVCC_PATH=$(which nvcc)
export CUDA_HOME=$(echo $NVCC_PATH | sed -e "s/\/bin\/nvcc//g")
export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH
export MPICH_RDMA_ENABLED_CUDA=1

