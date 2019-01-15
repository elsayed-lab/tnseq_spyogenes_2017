#!/usr/bin/env bash
#SBATCH --export=ALL
#SBATCH --mail-type=NONE
#SBATCH --workdir=/cbcb/nelsayed-scratch/atb/tnseq/spyogenes_5448v3/preprocessing/hpgl0864
#SBATCH --partition=dpart
#SBATCH --qos=workstation
#SBATCH --nodes=1
#SBATCH --time=10:00:00
#SBATCH --job-name=btv0M1_mgas_5448
#SBATCH --mem=6G
#SBATCH --cpus-per-task=4
#SBATCH --output=/cbcb/nelsayed-scratch/atb/tnseq/spyogenes_5448v3/preprocessing/hpgl0864/outputs/btv0M1_mgas_5448.sbatchout

echo "####Started /cbcb/nelsayed-scratch/atb/tnseq/spyogenes_5448v3/preprocessing/hpgl0864/scripts/10btv0M1_mgas_5448.sh at $(date)" >> outputs/log.txt
cd /cbcb/nelsayed-scratch/atb/tnseq/spyogenes_5448v3/preprocessing/hpgl0864 || exit

## This is a bowtie1 alignment of hpgl0864-trimmed_ca_ta.fastq against
## /cbcbhomes/abelew/libraries/genome/indexes/mgas_5448 using arguments:  --best -v 0 -M 1 .

mkdir -p outputs/bowtie_mgas_5448 && sleep 3 && bowtie /cbcbhomes/abelew/libraries/genome/indexes/mgas_5448  --best -v 0 -M 1  \
  -p 1 -q hpgl0864-trimmed_ca_ta.fastq \
  --un outputs/bowtie_mgas_5448/hpgl0864-v0M1_unaligned_mgas_5448.fastq \
  --al outputs/bowtie_mgas_5448/hpgl0864-v0M1_aligned_mgas_5448.fastq \
  -S outputs/bowtie_mgas_5448/hpgl0864-v0M1.sam \
  2>outputs/bowtie_mgas_5448/hpgl0864-v0M1.err \
  1>outputs/bowtie_mgas_5448/hpgl0864-v0M1.out

## The following lines give status codes and some logging
echo $? > outputs/status/btv0M1_mgas_5448.status
echo "###Finished ${SLURM_JOBID} 10btv0M1_mgas_5448.sh at $(date), it took $(( SECONDS / 60 )) minutes." >> outputs/log.txt

##walltime=$(qstat -f -t "${SLURM_JOBID}" | grep 'resources_used.walltime' | awk -F ' = ' '{print $2}')
##echo "#### walltime used by ${SLURM_JOBID} was: ${walltime:-null}" >> outputs/log.txt
##mem=$(qstat -f -t | grep "${SLURM_JOBID}" | grep 'resources_used.mem' | awk -F ' = ' '{print $2}')
##echo "#### memory used by ${SLURM_JOBID} was: ${mem:-null}" >> outputs/log.txt
##vmmemory=$(qstat -f -t "${SLURM_JOBID}" | grep 'resources_used.vmem' | awk -F ' = ' '{print $2}')
##echo "#### vmemory used by ${SLURM_JOBID} was: ${vmmemory:-null}" >> outputs/log.txt
##cputime=$(qstat -f -t "${SLURM_JOBID}" | grep 'resources_used.cput' | awk -F ' = ' '{print $2}')
##echo "#### cputime used by ${SLURM_JOBID} was: ${cputime:-null}" >> outputs/log.txt
####qstat -f -t ${SLURM_JOBID} >> outputs/log.txt

