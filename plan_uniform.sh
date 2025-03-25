#!/bin/bash

# Script pour lancer une matrice d'expériences

LEVEL_START=8
LEVEL_END=15

NTASKS_VALUES=(1 2 4 8 16 32)

# Boucle sur max-level
for ((level = $LEVEL_START; level <= $LEVEL_END; level++))
do
    # Boucle sur ntasks
    for ntasks in "${NTASKS_VALUES[@]}"
    do
        echo "Soumission job avec level=$level et ntasks=$ntasks"
        
        # Lancement du job avec sbatch
        sbatch ./testcase.sh \
            --max-level "$level" \
            --min-level "$level" \
            --ntasks "$ntasks"
        
#       sleep 1
    done
done

echo "Tous les jobs ont été soumis."
