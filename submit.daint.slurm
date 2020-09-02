#!/bin/bash
#SBATCH --job-name=<NAME>
#SBATCH --output=<OUTFILE>
#SBATCH --ntasks=<NTASKS>
#SBATCH --ntasks-per-node=<NTASKSPERNODE>
#SBATCH --cpus-per-task=<CPUSPERTASK>
#SBATCH --partition=<PARITION>
#SBATCH --time=00:30:00
#SBATCH --gres=gpu:1
#SBATCH --constraint=gpu
#SBATCH --partition=cscsci
#SBATCH --account=d107

########################################################

set -x
export OMP_NUM_THREADS=<CPUSPERTASK>
export MPICH_RDMA_ENABLED_CUDA=1
export MPICH_G2G_PIPELINE=256
export CRAY_CUDA_PROXY=0

<CMD>

########################################################
