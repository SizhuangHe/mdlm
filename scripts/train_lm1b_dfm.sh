#!/bin/bash
#SBATCH --job-name=dfm_lm1b
#SBATCH --output /home/sh2748/Job_Logs/CaLMDD/train_lm1b_dfm_%J.log
#SBATCH --mail-type=ALL
#SBATCH --mail-user=sizhuang.he@yale.edu
#SBATCH --partition=gpu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=2
#SBATCH --mem-per-cpu=64gb
#SBATCH --gpus=h100:2
#SBATCH --qos=qos_dijk
#SBATCH --time=1-00:00:00
cd /home/sh2748/mdlm
module load miniconda
conda activate c2s2

srun /gpfs/radev/home/sh2748/.conda/envs/c2s2/bin/python main.py \
  loader.global_batch_size=512 \
  model=small \
  data=lm1b \
  wandb.name=dfm-lm1b \
  parameterization=d3pm \
  model.length=128 \
  eval.compute_generative_perplexity=True \
  sampling.steps=1000 \
  sampling.predictor=ddpm \
  time_conditioning=True \
  T=1000 \
  ++dfm=True \
  trainer.devices=2 \
  trainer.val_check_interval=10000 \
  checkpointing.save_dir=/gpfs/radev/scratch/dijk/sh2748/CaLMDD/benchmarking_runs/lm1b/2025.01.28/184539 \
  checkpointing.resume_from_ckpt=True \
  checkpointing.resume_ckpt_path=/gpfs/radev/scratch/dijk/sh2748/CaLMDD/benchmarking_runs/lm1b/2025.01.28/184539/checkpoints/best.ckpt