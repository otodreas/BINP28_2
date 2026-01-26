# remove and recreate the prodigal outputs directory
rm -rf ./prodigal_outputs
mkdir ./prodigal_outputs
# run prodigal twice, once to make the training file, and once to apply it
prodigal -i ./prodigal_input/Assembly.fasta -a ./prodigal_outputs/geoGenes.fna -c -d ./prodigal_outputs/geoProteins.faa -f gff -m -o ./prodigal_outputs/geo.gff -t ./prodigal_outputs/geoTraining
prodigal -i ./prodigal_input/Assembly.fasta -a ./prodigal_outputs/geoGenes.fna -c -d ./prodigal_outputs/geoProteins.faa -f gff -m -o ./prodigal_outputs/geo.gff -t ./prodigal_outputs/geoTraining