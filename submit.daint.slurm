#!/bin/bash
#SBATCH --constraint=gpu
#SBATCH --job-name=<NAME>
#SBATCH --ntasks=<NTASKS>
#SBATCH --ntasks-per-node=<NTASKSPERNODE>
#SBATCH --cpus-per-task=<CPUSPERTASK>
#SBATCH --output=<OUTFILE>
#SBATCH --time=<TIMEOUT>
#SBATCH --gres=gpu:1
#SBATCH --account=s1053
#SBATCH --partition=cscsci

# NOTE: time can be either in HH:MM:SS or simply minutes if an int

########################################################

set -x
export OMP_NUM_THREADS=<CPUSPERTASK>

<CMD>

########################################################
