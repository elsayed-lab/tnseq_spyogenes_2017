#!/usr/bin/env bash
#SBATCH --export=ALL
#SBATCH --mail-type=NONE
#SBATCH --workdir=/cbcb/nelsayed-scratch/atb/tnseq/spyogenes_5448v3/preprocessing/hpgl0864
#SBATCH --partition=dpart
#SBATCH --qos=workstation
#SBATCH --nodes=1
#SBATCH --time=10:00:00
#SBATCH --job-name=tn_hmm
#SBATCH --mem=6G
#SBATCH --cpus-per-task=1
#SBATCH --output=/cbcb/nelsayed-scratch/atb/tnseq/spyogenes_5448v3/preprocessing/hpgl0864/outputs/tn_hmm.sbatchout

echo "####Started /cbcb/nelsayed-scratch/atb/tnseq/spyogenes_5448v3/preprocessing/hpgl0864/scripts/15tn_hmm.sh at $(date)" >> outputs/log.txt
cd /cbcb/nelsayed-scratch/atb/tnseq/spyogenes_5448v3/preprocessing/hpgl0864 || exit

## Performing tn_hmm on outputs/essentiality/hpgl0864-v0M1.wig using /cbcb/nelsayed-scratch/atb/libraries/genome/mgas_5448.gff

## This only works with python 2.7.9
eval $(modulecmd bash purge)
eval $(modulecmd bash add Python2/2.7.9)
eval $(modulecmd bash add essentiality)
if [ "Python 2.7.9" != "$(python --version 2>&1)" ]; then
  echo "tn-hmm only works with python 2.7.9, do some module shenanigans."
  exit 1
fi

tn-hmm.py -f outputs/essentiality/hpgl0864-v0M1.wig -gff /cbcb/nelsayed-scratch/atb/libraries/genome/mgas_5448.gff \
  1>outputs/essentiality/tn_hmm-hpgl0864-v0M1_gene_tas.csv \
  2>outputs/essentiality/tn_hmm-hpgl0864-v0M1_gene_tas.err

process_genes.py -f outputs/essentiality/tn_hmm-hpgl0864-v0M1_gene_tas.csv \
  1>outputs/essentiality/genes_tn_hmm-hpgl0864-v0M1_gene_tas.csv \
  2>outputs/essentiality/genes_tn_hmm-hpgl0864-v0M1_gene_tas.err

process_segments.py -f outputs/essentiality/tn_hmm-hpgl0864-v0M1_gene_tas.csv \
  1>outputs/essentiality/segments_tn_hmm-hpgl0864-v0M1_gene_tas.csv \
  2>outputs/essentiality/segments_tn_hmm-hpgl0864-v0M1_gene_tas.err

## The following lines give status codes and some logging
echo $? > outputs/status/tn_hmm.status
echo "###Finished ${SLURM_JOBID} 15tn_hmm.sh at $(date), it took $(( SECONDS / 60 )) minutes." >> outputs/log.txt

##walltime=$(qstat -f -t "${SLURM_JOBID}" | grep 'resources_used.walltime' | awk -F ' = ' '{print $2}')
##echo "#### walltime used by ${SLURM_JOBID} was: ${walltime:-null}" >> outputs/log.txt
##mem=$(qstat -f -t | grep "${SLURM_JOBID}" | grep 'resources_used.mem' | awk -F ' = ' '{print $2}')
##echo "#### memory used by ${SLURM_JOBID} was: ${mem:-null}" >> outputs/log.txt
##vmmemory=$(qstat -f -t "${SLURM_JOBID}" | grep 'resources_used.vmem' | awk -F ' = ' '{print $2}')
##echo "#### vmemory used by ${SLURM_JOBID} was: ${vmmemory:-null}" >> outputs/log.txt
##cputime=$(qstat -f -t "${SLURM_JOBID}" | grep 'resources_used.cput' | awk -F ' = ' '{print $2}')
##echo "#### cputime used by ${SLURM_JOBID} was: ${cputime:-null}" >> outputs/log.txt
####qstat -f -t ${SLURM_JOBID} >> outputs/log.txt

