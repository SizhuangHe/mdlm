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
date;hostname;pwd

cd /home/sh2748/mdlm
module load miniconda
conda activate c2s2
python main.py \
  loader.batch_size=128 \
  loader.eval_batch_size=128 \
  model=small \
  data=acyp \
  wandb.name=sedd-acyp \
  parameterization=sedd \
  model.length=128 \
  eval.compute_generative_perplexity=True \
  sampling.steps=1000 \
  sampling.predictor=analytic \
  time_conditioning=True \
  T=0 \
  trainer.check_val_every_n_epoch=10
