#!/bin/bash
RUN_CMD_FILE=$1
SCRIPT=$2
OUT=$3
maxsleep=9000
envdir=`dirname $0`
. ${envdir}/machineEnvironment.sh


if [ "${scheduler}" = "slurm" ] ; then
    # check if SLURM script exists, if not, use the standard one defined by the host
    test -f ${SCRIPT} || SCRIPT="${envdir}/submit.${host}.slurm"
    # test if the SLURM script exists, if not, scheduler should not be slurm
    test -f ${SCRIPT} || exitError 1252 ${LINENO} "cannot find script ${SCRIPT}"

    # load slurm tools
    if [ ! -f  ${envdir}/slurmTools.sh ] ; then
	exitError 1203 ${LINENO} "could not find ${envdir}/slurmTools.sh"
    fi
    . ${envdir}/slurmTools.sh


    # setup SLURM job
    # set a generic output filename if it's not provided as an input
    if [ -z ${OUT} ] ; then
	OUT="Job${BUILD_ID}.out"
    fi
   
    # These should get set here
    /bin/sed -i 's|<OUTFILE>|'"${OUT}"'|g' ${SCRIPT}
    /bin/sed -i 's|<CMD>|'"bash ${RUN_CMD_FILE}"'|g' ${SCRIPT}
    # These should be set before this script is called, but if not, will get these default values
    /bin/sed -i 's|<NAME>|job|g' ${SCRIPT}
    /bin/sed -i 's|<NTASKS>|1|g' ${SCRIPT}
    /bin/sed -i 's|<NTASKSPERNODE>|'"${nthreads}"'|g' ${SCRIPT}
    /bin/sed -i 's|<CPUSPERTASK>|1|g' ${SCRIPT}

    # The contents of the resulting script to be submitted
    echo "Submitting slurm script:"
    cat ${SCRIPT}

    # submit SLURM job
    launch_job ${SCRIPT} ${maxsleep}
    if [ $? -ne 0 ] ; then
	exitError 1251 ${LINENO} "problem launching SLURM job ${SCRIPT}"
    fi

    # echo output of SLURM job
    cat ${OUT}
    rm ${OUT}

else
    bash ${RUN_CMD_FILE}
fi
