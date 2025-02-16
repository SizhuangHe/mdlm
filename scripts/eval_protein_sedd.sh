#!/bin/bash
#SBATCH --job-name=train_protein
#SBATCH --output /home/sh2748/Job_Logs/protein_benchmark/D3PM%J.log
#SBATCH --mail-type=ALL
#SBATCH --mail-user=sizhuang.he@yale.edu
#SBATCH --partition=gpu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem-per-cpu=32gb
#SBATCH --gpus=1
#SBATCH --constraint="h100|a100"
#SBATCH --time=6:00:00

checkpoint_path=/gpfs/radev/scratch/dijk/sh2748/CaLMDD/benchmarking_runs/acyp/2025.01.15/161304/checkpoints/last.ckpt
export HYDRA_FULL_ERROR=1

module load miniconda
conda activate c2s2
cd /home/sh2748/mdlm

python main.py \
  mode=sample_eval \
  loader.batch_size=128 \
  loader.eval_batch_size=128 \
  data=acyp \
  model=small \
  parameterization=sedd \
  backbone=dit \
  model.length=128 \
  eval.checkpoint_path=$checkpoint_path \
  time_conditioning=True \
  T=0 \
  +wandb.offline=true
