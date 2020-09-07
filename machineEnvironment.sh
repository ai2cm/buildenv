#!/bin/bash

# setup environment for different systems
# 
# NOTE: the location of the base bash script and module initialization
#       vary from system to system, so you will have to add the location
#       if your system is not supported below

exitError()
{
    \rm -f /tmp/tmp.${user}.$$ 1>/dev/null 2>/dev/null
    echo "ERROR $1: $3" 1>&2
    echo "ERROR     LOCATION=$0" 1>&2
    echo "ERROR     LINE=$2" 1>&2
    exit $1
}

showWarning()
{
    echo "WARNING $1: $3" 1>&2
    echo "WARNING       LOCATION=$0" 1>&2
    echo "WARNING       LINE=$2" 1>&2
}

modulepathadd() {
    if [ -d "$1" ] && [[ ":$MODULEPATH:" != *":$1:"* ]]; then
        MODULEPATH="${MODULEPATH:+"$MODULEPATH:"}$1"
    fi
}

# setup empty defaults
host=""          # name of host
queue=""         # standard queue to submit jobs to
nthreads=""      # number of threads to use for parallel builds
mpilaunch=""     # command to launch an MPI executable (e.g. aprun)
installdir=""    # directory where libraries are installed
scheduler=""     # e.g. none, slurm, pbs

# set default value for useslurm based on whether a submit script exists
envdir=`dirname $0`
# setup machine specifics
if [ "`hostname | grep daint`" != "" ] ; then
    . /etc/bash.bashrc
    . /opt/modules/default/init/bash
    . /etc/bash.bashrc.local
    export host="daint"
    scheduler="slurm"
    queue="normal"
    nthreads=8
    mpilaunch="srun"
    installdir=/project/d107/install/${host}
    export CUDA_ARCH=sm_60
elif [ "`hostname | grep papaya`" != "" ] ; then
    alias module=echo
    export host="papaya"
    scheduler="none"
    queue="normal"
    nthreads=6
    mpilaunch="mpirun"
    installdir=/Users/OliverF/Desktop/install
elif [ "`hostname | grep ubuntu-1804`" != "" ] ; then
    alias module=echo
    export host="gce"
    scheduler="none"
    queue="normal"
    nthreads=6
    mpilaunch="mpirun"
    installdir=/tmp
    if [ ! -z "`command -v nvidia-smi`" ] ; then
        nvidia-smi 2>&1 1>/dev/null
        if [ $? -eq 0 ] ; then
            export CUDA_ARCH=sm_60
        fi
    fi
elif [ "`hostname | grep kesch`" != "" -o "`hostname | grep escha`" != "" ] ; then
    . /etc/bashrc && true # In some conditions the omitted true triggered an error.
    if [ "${NODE_NAME}" == kesch-pgi ] ; then
        export host="kesch-pgi"
    else
        export host="kesch"
    fi
    scheduler="slurm"
    queue="debug"
    nthreads=1
    mpilaunch="srun"
    installdir="/project/d107/install/${host}"
    export CUDA_ARCH=sm_37
elif [ "`hostname | grep arolla`" != "" -o "`hostname | grep tsa`" != "" ] ; then
    . /etc/bashrc
    export host="tsa"
    scheduler="slurm"
    queue="debug"
    nthreads=1
    mpilaunch="srun"
    installdir="/project/d107/install/tsa"
    export CUDA_ARCH=sm_70
elif [ "${CIRCLECI}" == "true" ] ; then
    alias module=echo
    export host="circleci"
    queue="normal"
    nthreads=6
    mpilaunch="mpirun"
    installdir=/tmp
fi

# make sure everything is set
test -n "${host}" || exitError 2001 ${LINENO} "Variable <host> could not be set (unknown machine `hostname`?)"
test -n "${queue}" || exitError 2002 ${LINENO} "Variable <queue> could not be set (unknown machine `hostname`?)"
test -n "${scheduler}" || exitError 2002 ${LINENO} "Variable <scheduler> could not be set (unknown machine `hostname`?)"
test -n "${nthreads}" || exitError 2003 ${LINENO} "Variable <nthreads> could not be set (unknown machine `hostname`?)"
test -n "${mpilaunch}" || exitError 2004 ${LINENO} "Variable <mpilaunch> could not be set (unknown machine `hostname`?)"
test -n "${installdir}" || exitError 2005 ${LINENO} "Variable <installdir> could not be set (unknown machine `hostname`?)"

# export installation directory
export INSTALL_DIR="${installdir}"

