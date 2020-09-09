# Build Environment

`buildenv` is a repository that tries to "abstract" the specific environments on different systems in order to simplify writing bash scripts on these systems and make results reproducible (for exmple for a CI system). Depending on the use-case, this repository can simply be cloned or sub-moduled into a working environment.

It currently contains the following components:
- Defines a set of standardized variables (host, scheduler, queue, nthreads, mpilaunch, ...) in `machineEnvironment.sh`
- Defines a machine-specific environment (module load ..., export LD_LIBRARY_PATH=...) in `env.${host}.sh` scripts that can be sourced.
- Provides a set of tools for working with/without a scheduler (e.g. SLURM) in `schedulerTools.sh` and host-specific template job submission scripts in `submit.${host}.${scheduler}`.
- Provides a set of tools for querying the git environment (if in a git repo) in `gitTools.sh`.
- Provides a set of tools for working with a system that uses modules in `moduleTools.sh`.
- Provides functionality to issue errors and warnings in `machineEnvironment.sh`.

# Usage

The functionality of `buildenv` is typically accessed from a shell script in the following way...

```bash
#!/bin/bash

envloc="."

# get latest version of buildenv
if [ -d ${envloc}/env ] ; then
    cd ${envloc}; git pull; cd -
else
    git clone git@github.com:VulcanClimateModeling/buildenv.git ${envloc}/env
fi

# setup module environment and default queue
if [ ! -f ${envloc}/env/machineEnvironment.sh ] ; then
    echo "Error 1000 in $0 L${LINENO}: Could not find ${envloc}/env/machineEnvironment.sh"
    exit 1
fi
. ${envloc}/env/machineEnvironment.sh

# load machine dependent environment
if [ ! -f ${envloc}/env/env.${host}.sh ] ; then
    exitError 1001 ${LINENO} "could not find ${envloc}/env/env.${host}.sh"
fi
. ${envloc}/env/env.${host}.sh

# load scheduler tools
if [ ! -f ${envloc}/env/schedulerTools.sh ] ; then
    exitError 1002 ${LINENO} "could not find ${envloc}/env/schedulerTools.sh"
fi
. ${envloc}/env/schedulerTools.sh

# rest of script
```

# Example

An example of how `buildenv` is being used in a Jenkins CI plan can be found [here](https://github.com/VulcanClimateModeling/fv3gfs-wrapper/tree/master/.jenkins).

