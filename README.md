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

The functionality of `buildenv` is typically accessed from a shell script as in the bash script below. 

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
. ${envloc}/env/machineEnvironment.sh

# load machine dependent environment
. ${envloc}/env/env.${host}.sh

# load scheduler tools (provides run_command)
. ${envloc}/env/schedulerTools.sh

# rest of script (which uses buildenv functionality)
echo "I am running on host ${host} with scheduler ${scheduler}."
run_command "echo 'This submits a job on systems which have a batch system'"
...

```

# Example

An example of how `buildenv` is being used in a Jenkins CI plan can be found [here](https://github.com/VulcanClimateModeling/fv3gfs-wrapper/tree/master/.jenkins).

