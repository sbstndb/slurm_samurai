#!/bin/bash

# Script pour lancer une matrice d'expériences

MAX_LEVEL_START=8
MAX_LEVEL_END=15

NTASKS_VALUES=(1 2 4 8 16 32)

# Boucle sur max-level
for ((max_level = $MAX_LEVEL_START; max_level <= $MAX_LEVEL_END; max_level++))
do
    # Boucle sur ntasks
    for ntasks in "${NTASKS_VALUES[@]}"
    do
        echo "Soumission job avec max-level=$max_level et ntasks=$ntasks"
        
        # Lancement du job avec sbatch
        sbatch ./test.sh \
            --max-level "$max_level" \
            --ntasks "$ntasks"
        
#       sleep 1
    done
done

echo "Tous les jobs ont été soumis."

