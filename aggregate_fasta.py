from datetime import datetime
import os
import argparse
from ipdb import set_trace
def aggregate_fasta_files(folder_path, output_folder):
    # Output file path
    if output_folder is None:
        output_folder = folder_path
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)
    base_output_file = os.path.join(output_folder, 'aggregated_sequences.fasta')
    
    # Check if the aggregated FASTA file already exists
    if os.path.exists(base_output_file):
        # Generate a timestamp
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        # Create a new output file name with the timestamp
        output_file = os.path.join(output_folder, f'aggregated_sequences_{timestamp}.fasta')
        print(f"Output file already exists. New file will be created at: {output_file}")
    else:
        output_file = base_output_file
    
    with open(output_file, 'w') as outfile:
        # Loop through all files in the specified folder
        for filename in os.listdir(folder_path):
            if (filename.endswith('.fasta') or filename.endswith('.fa')) and 'aggregated' not in filename:
                file_path = os.path.join(folder_path, filename)
                with open(file_path, 'r') as infile:
                    # Write the contents of the FASTA file to the output file
                    # Technically, the identifiers should be different but in our case, who cares. We are not actually reading it as a fasta file.
                    outfile.write(infile.read())

    print(f"Aggregated FASTA file created at: {output_file}")

def main():
    # Set up argument parsing
    parser = argparse.ArgumentParser(description="Aggregate FASTA files from a specified folder.")
    parser.add_argument('--folder', type=str, help='Path to the folder containing FASTA files.')
    parser.add_argument('--output_folder', type=str, help='Path to the folder to save the aggregated FASTA file.')

    # Parse the arguments
    args = parser.parse_args()

    # Call the aggregation function
    aggregate_fasta_files(args.folder, args.output_folder)

if __name__ == '__main__':
    main()