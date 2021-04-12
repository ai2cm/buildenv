#!/bin/bash

# This script contains functions for setting up machine specific compile
# environments for the dycore and the Fortran parts. Namely, the following
# functions must be defined in this file:

module load daint-gpu
module swap PrgEnv-cray PrgEnv-gnu
module load cdt-cuda/20.11
module load cudatoolkit/11.0.2_3.33-7.0.2.1_3.1__g1ba0366
module load cray-python/3.8.5.0
module load Boost/1.70.0-CrayGNU-20.11-python3
module switch gcc gcc/9.3.0
module load graphviz/2.44.0

NVCC_PATH=$(which nvcc)
export CUDA_HOME=$(echo $NVCC_PATH | sed -e "s/\/bin\/nvcc//g")
export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH
export MPICH_RDMA_ENABLED_CUDA=1
