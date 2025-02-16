#!/bin/bash
#SBATCH --job-name=mdlm-lm1b
#SBATCH --output /home/sh2748/Job_Logs/CaLMDD/train_lm1b_mdlm_%J.log
#SBATCH --mail-type=ALL
#SBATCH --mail-user=sizhuang.he@yale.edu
#SBATCH --partition=gpu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem-per-cpu=64gb
#SBATCH --gpus=h100:1
#SBATCH --qos=qos_dijk
#SBATCH --time=1-00:00:00

cd /home/sh2748/mdlm
module load miniconda
conda activate c2s2

python main.py \
  loader.batch_size=256 \
  loader.eval_batch_size=256 \
  model=small \
  data=lm1b \
  wandb.name=mdlm-lm1b \
  parameterization=subs \
  model.length=128 \
  eval.compute_generative_perplexity=True \
  sampling.steps=1000 \
  sampling.predictor=ddpm \
  time_conditioning=True \
  T=1000 \
  trainer.val_check_interval=30000 \
  checkpointing.save_dir=/gpfs/radev/scratch/dijk/sh2748/CaLMDD/benchmarking_runs/lm1b/2025.01.22/231637 \
  checkpointing.resume_from_ckpt=True \
  checkpointing.resume_ckpt_path=/gpfs/radev/scratch/dijk/sh2748/CaLMDD/benchmarking_runs/lm1b/2025.01.22/231637/checkpoints/6-323000.ckpt