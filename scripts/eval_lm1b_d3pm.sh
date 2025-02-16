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

sample_steps=1000
temperature=0.7
checkpoint_path="/gpfs/radev/scratch/dijk/sh2748/CaLMDD/benchmarking_runs/lm1b/2025.01.21/002624/checkpoints/best.ckpt"
fasta_folder="/gpfs/radev/scratch/dijk/sh2748/CaLMDD/benchmarking_runs/lm1b/2025.01.21/002624/eval_results/T_${temperature}/${sample_steps}_steps"
aggregated_fasta_filename="aggregated_sequences.fasta"
aggregated_fasta_path="${fasta_folder}/${aggregated_fasta_filename}"

echo "Start sampling with ${sample_steps} steps"


export HYDRA_FULL_ERROR=1

module load miniconda
conda activate c2s2
cd /home/sh2748/mdlm



sample_params=(
  "10 13"
  "15 12"
  "20 14"
  "25 19"
  "30 12"
  "35 13"
  "40 10"
  "45 6"
  "50 1"
)

# Loop over each pair with an index
for i in "${!sample_params[@]}"; do
  # Extract the current pair
  pair=${sample_params[$i]}
  
  # Extract sample_length and num_samples as integers
  sample_length=$(( $(echo $pair | cut -d ' ' -f 1) ))  # Convert to integer
  num_samples=$(( $(echo $pair | cut -d ' ' -f 2) ))    # Convert to integer

  # Print the index for reference (optional)
  echo "Temperature: $temperature"
  echo "Running for index $i: sample_length = $sample_length, num_samples = $num_samples"

  # Run the Python script with the current pair
  python main.py \
    mode=sample_eval \
    loader.batch_size=20 \
    loader.eval_batch_size=$num_samples \
    data=lm1b \
    model=small \
    parameterization=d3pm \
    backbone=dit \
    model.length=$sample_length \
    eval.checkpoint_path=$checkpoint_path \
    time_conditioning=True \
    sampling.steps=$sample_steps \
    sampling.predictor=ddpm \
    sampling.num_sample_batches=1 \
    ++sampling.fasta_index=$i \
    T=1000 \
    +wandb.offline=true \
    ++sampling.temperature=$temperature
done

echo "Start aggregating fasta files..."
# Aggregate the fasta files
python aggregate_fasta.py --folder=$fasta_folder

echo "Save fasta to ${aggregated_fasta_path}"
# cd /home/sh2748/CaLMDD
# python compute_gen_ppl.py fasta_file_path=$aggregated_fasta_path