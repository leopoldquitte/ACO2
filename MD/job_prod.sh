#!/bin/bash
#SBATCH -J "ACO2_1"
#SBATCH --account=def-adroit_gpu
#SBATCH -t 36:00:00          # 5 jours
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --cpus-per-task=8
#SBATCH --gres=gpu:h100:1
#SBATCH --mem=50G
#SBATCH --output=prod_1us.log

# Chargement des modules
ml --force purge
module load StdEnv/2023 gcc/12.3 openmpi/4.1.5 cuda/12.6
module load amber-pmemd/24.3
ulimit -s 86400

# Variables
PRM="system_solv.prmtop"
INPC="eq_free.rst"
EXE="pmemd.cuda"

echo "Démarrage de la production d'une microseconde..."
echo "Début : $(date)"

# Lancement de la simulation
$EXE -O -i prod.in -o prod_1us2.out -p $PRM -c prod_1us.rst -r prod_1us2.rst -x prod_1us2.nc

echo "Fin de la simulation : $(date)"
