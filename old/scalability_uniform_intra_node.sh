#!/bin/bash
#SBATCH --job-name=advection-2d_scalability
#SBATCH --output=slurm_output_%j.txt
#SBATCH --partition=cpu_shared        # À adapter selon votre configuration
#SBATCH --nodes=1                   # À adapter selon le nombre de nœuds requis
#SBATCH --ntasks-per-node=32        # Exemple : 32 tâches par nœud
#SBATCH --time=04:00:00             # Temps maximum d'exécution
#SBATCH --account=samurai

# Chargement des modules via spack
module purge
module load gcc/13
. $WORKDIR/spack/share/spack/setup-env.sh
spack load samurai + mpi ^intel-oneapi-mpi

# Tableau des valeurs de np (nombre de processus) à tester
NP_VALUES=(16 32)

# Tableau des valeurs de max-level à tester
MAX_LEVELS=(6 8 10 12 14 15)

# Boucle sur les valeurs de np et de max-level
for np in "${NP_VALUES[@]}"; do
  for level in "${MAX_LEVELS[@]}"; do
    echo "Lancement de linear-convection avec np=${np} et --max-level=${level}"
    
    # Exécution via mpilaunch (assurez-vous que mpilaunch est dans le PATH)
    mpirun -np ${np} $WORKDIR/samurai/build_mpi/demos/FiniteVolume/finite-volume-advection-2d --Tf 0.05 --min-level ${level} --max-level ${level} --timers > output_slurm_np${np}_level${level}.txt 2>&1
    
    # Vous pouvez ajouter ici une pause ou une gestion d'erreur si besoin
  done
done

echo "Tous les jobs de scalabilité ont été lancés."

