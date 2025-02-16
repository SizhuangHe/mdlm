#!/bin/bash
#SBATCH --job-name=dfm_lm1b
#SBATCH --output /home/sh2748/Job_Logs/CaLMDD/train_lm1b_dfm_%J.log
#SBATCH --mail-type=ALL
#SBATCH --mail-user=sizhuang.he@yale.edu
#SBATCH --partition=gpu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem-per-cpu=64gb
#SBATCH --gpus=a100:1
#SBATCH --time=14:00:00
cd /home/sh2748/mdlm
module load miniconda
conda activate c2s2

python main.py \
  loader.global_batch_size=128 \
  model=small \
  data=acyp \
  wandb.name=dfm-acyp \
  parameterization=d3pm \
  model.length=128 \
  eval.compute_generative_perplexity=True \
  sampling.steps=1000 \
  sampling.predictor=ddpm \
  time_conditioning=True \
  T=1000 \
  ++dfm=True \
  trainer.devices=1 \
  trainer.val_check_interval=1000 \
  checkpointing.save_dir=/gpfs/radev/scratch/dijk/sh2748/CaLMDD/benchmarking_runs/acyp/2025.01.28/164458 \
  checkpointing.resume_from_ckpt=True \
  checkpointing.resume_ckpt_path=/gpfs/radev/scratch/dijk/sh2748/CaLMDD/benchmarking_runs/acyp/2025.01.28/164458/checkpoints/249-18000.ckpt