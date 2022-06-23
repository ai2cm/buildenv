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


########################################################

set -x
export OMP_NUM_THREADS=<CPUSPERTASK>

<CMD>

########################################################
