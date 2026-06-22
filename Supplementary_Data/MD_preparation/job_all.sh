#!/bin/bash
#SBATCH -J "4Fe4S_Relax"
#SBATCH --account=def-adroit_gpu
#SBATCH -t 24:00:00           # 24h pour être large
#SBATCH -N 1                  # 1 nœud
#SBATCH -n 1                  # 1 tâche
#SBATCH --cpus-per-task=8     # Threads CPU pour le GPU
#SBATCH --gres=gpu:h100:1     # 1 GPU H100 complet
#SBATCH --mem=50G
#SBATCH --output=md_%j.log

# Chargement des modules (Version 24 compatible H100)
ml --force purge
module load StdEnv/2023 gcc/12.3 openmpi/4.1.5 cuda/12.6
module load amber-pmemd/24.3
ulimit -s 86400

# Variables de fichiers
PRM="system_solv.prmtop"
CRD="system_solv.inpcrd"
EXE="pmemd.cuda"

# Sécurité : arrêt si un fichier est absent
if [[ ! -f "$PRM" || ! -f "$CRD" ]]; then
    echo "ERREUR : Fichiers $PRM ou $CRD introuvables."
    exit 1
fi

# Fonction de vérification après chaque étape
check_step() {
    if [ ! -f "$1" ]; then
        echo "ERREUR CRITIQUE : Le fichier $1 n'a pas été généré. Arrêt du script."
        exit 1
    fi
}

echo "--- Démarrage de la Relaxation sur H100 ---"

echo "Étape 1 : Minimisation 1 (Contraintes fortes 50 kcal/mol)..."
$EXE -O -i mini1.in -o mini1.out -p $PRM -c $CRD -ref $CRD -r mini1.rst
check_step "mini1.rst"

echo "Étape 2 : Minimisation 2 (Contraintes moyennes 10 kcal/mol)..."
$EXE -O -i mini2.in -o mini2.out -p $PRM -c mini1.rst -ref mini1.rst -r mini2.rst
check_step "mini2.rst"

echo "Étape 3 : Minimisation 4 (Système libre)..."
$EXE -O -i mini4.in -o mini4.out -p $PRM -c mini2.rst -r mini4.rst
check_step "mini4.rst"

echo "Étape 4 : Chauffage progressive (0 à 300K)..."
$EXE -O -i heat.in -o heat.out -p $PRM -c mini4.rst -ref mini4.rst -r heat.rst -x heat.nc
check_step "heat.rst"

echo "Étape 5 : Équilibration NPT (Contraintes 10 kcal/mol)..."
$EXE -O -i eq_heavy.in -o eq_heavy.out -p $PRM -c heat.rst -ref heat.rst -r eq_heavy.rst
check_step "eq_heavy.rst"

echo "Étape 6 : Équilibration NPT (Contraintes 2 kcal/mol)..."
$EXE -O -i eq_medium.in -o eq_medium.out -p $PRM -c eq_heavy.rst -ref eq_heavy.rst -r eq_medium.rst
check_step "eq_medium.rst"

echo "Étape 7 : Équilibration NPT finale (Libre)..."
$EXE -O -i eq_free.in -o eq_free.out -p $PRM -c eq_medium.rst -ref eq_medium.rst -r eq_free.rst
check_step "eq_free.rst"

echo "### Relaxation terminée avec succès ! ###"
