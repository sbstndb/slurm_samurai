#!/bin/bash
#SBATCH --job-name=samurai
#SBATCH --output=slurm_output_%j.txt
#SBATCH --partition=cpu_dist
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=40
#SBATCH --time=04:00:00        
#SBATCH --account=samurai

# Chargement des modules via spack
module purge
module load gcc/13
. $WORKDIR/spack/share/spack/setup-env.sh
spack load samurai + mpi ^openmpi@4.1.6
BUILD="build_openmpi"
#spack load samurai ~mpi
#BUILD="build"
#spack load samurai + mpi ^intel-oneapi-mpi
#BUILD="build_mpi"

# Valeurs par défaut
FOLDER="samurai"
BUILD="build_openmpi"
MAX_LEVEL=13
MIN_LEVEL=6
NTASKS=128
NFILES=1
BINARY="finite-volume-advection-2d"
TF=0.1

# Récupération des arguments passés à sbatch
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --samurai-folder) FOLDER="$2"; shift ;;
        --max-level) MAX_LEVEL="$2"; shift ;;
        --min-level) MIN_LEVEL="$2"; shift ;;
        --ntasks) NTASKS="$2"; shift ;;
        --nfiles) NFILES="$2"; shift ;;
        --binary) BINARY="$2"; shift ;;
        --Tf) TF="$2"; shift ;;     
        *) echo "Argument inconnu: $1"; exit 1 ;;
    esac
    shift
done

echo "Lancement de $BINARY avec les paramètres suivants :"
echo -e "\t--folder=${FOLDER}"
echo -e "\t--build_directory=${BUILD}"
echo -e "\t--ntasks=${NTASKS}"
echo -e "\t--max-level=${MAX_LEVEL}"
echo -e "\t--min-level=${MIN_LEVEL}"
echo -e "\t--nfiles=${NFILES}"
echo -e "\t--Tf=${TF}"



mpirun -np ${NTASKS} $WORKDIR/${FOLDER}/${BUILD}/demos/FiniteVolume/${BINARY} \
    --Tf ${TF} --min-level ${MIN_LEVEL} --max-level ${MAX_LEVEL} --timers --nfiles ${NFILES} \
    > output_slurm_minlevel${MIN_LEVEL}_maxlevel${MAX_LEVEL}_ntasks${NTASKS}.txt 2>&1

echo "Job terminé."

