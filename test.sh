#!/bin/bash
#SBATCH --job-name=samurai # Nom du job par défaut si non spécifié
#SBATCH --output=slurm_output_%j.txt
#SBATCH --partition=cpu_shared
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=40  # Nombre de tâches, par défaut 32
#SBATCH --time=04:00:00         # Temps d'exécution, par défaut 4h
#SBATCH --account=samurai

# Chargement des modules via spack
module purge
module load gcc/13
. $WORKDIR/spack/share/spack/setup-env.sh
spack load samurai + mpi ^openmpi@4.1.6

# Valeurs par défaut
FOLDER="samurai"
MPI="build_openmpi"
MAX_LEVEL=10
MIN_LEVEL=5
NTASKS=1
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
echo -e "\t--mpi_directory=${MPI}"
echo -e "\t--ntasks=${NTASKS}"
echo -e "\t--max-level=${MAX_LEVEL}"
echo -e "\t--min-level=${MIN_LEVEL}"
echo -e "\t--nfiles=${NFILES}"
echo -e "\t--Tf=${TF}"



mpirun -np ${NTASKS} $WORKDIR/${FOLDER}/${MPI}/demos/FiniteVolume/${BINARY} \
    --Tf ${TF} --min-level ${MIN_LEVEL} --max-level ${MAX_LEVEL} --timers --nfiles ${NFILES} \
    > output_slurm_maxlevel${MAX_LEVEL}.txt 2>&1

echo "Job terminé."


