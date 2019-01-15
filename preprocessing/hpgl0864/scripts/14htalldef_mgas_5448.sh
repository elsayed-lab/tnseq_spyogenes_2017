#!/usr/bin/env bash
#SBATCH --export=ALL
#SBATCH --mail-type=NONE
#SBATCH --workdir=/cbcb/nelsayed-scratch/atb/tnseq/spyogenes_5448v3/preprocessing/hpgl0864
#SBATCH --partition=dpart
#SBATCH --qos=workstation
#SBATCH --nodes=1
#SBATCH --time=10:00:00
#SBATCH --job-name=htalldef_mgas_5448
#SBATCH --mem=6G
#SBATCH --cpus-per-task=4
#SBATCH --output=/cbcb/nelsayed-scratch/atb/tnseq/spyogenes_5448v3/preprocessing/hpgl0864/outputs/htalldef_mgas_5448.sbatchout

echo "####Started /cbcb/nelsayed-scratch/atb/tnseq/spyogenes_5448v3/preprocessing/hpgl0864/scripts/14htalldef_mgas_5448.sh at $(date)" >> outputs/log.txt
cd /cbcb/nelsayed-scratch/atb/tnseq/spyogenes_5448v3/preprocessing/hpgl0864 || exit

## Counting the number of hits in outputs/bowtie_mgas_5448/hpgl0864-def.bam for each feature found in /cbcbhomes/abelew/libraries/genome/mgas_5448.gff
## Is this stranded? no.  The defaults of htseq are:
##  --order=name --idattr=gene_id --minaqual=10 --type=exon --stranded=yes --mode=union 

htseq-count -q -f bam -s no   \
  outputs/bowtie_mgas_5448/hpgl0864-def.bam \
  /cbcbhomes/abelew/libraries/genome/mgas_5448.gff \
  1>outputs/bowtie_mgas_5448/hpgl0864-def_def.count 2>outputs/bowtie_mgas_5448/hpgl0864-def_htseq.err && \
    xz -f -9e outputs/bowtie_mgas_5448/hpgl0864-def_def.count

## The following lines give status codes and some logging
echo $? > outputs/status/htalldef_mgas_5448.status
echo "###Finished ${SLURM_JOBID} 14htalldef_mgas_5448.sh at $(date), it took $(( SECONDS / 60 )) minutes." >> outputs/log.txt

##walltime=$(qstat -f -t "${SLURM_JOBID}" | grep 'resources_used.walltime' | awk -F ' = ' '{print $2}')
##echo "#### walltime used by ${SLURM_JOBID} was: ${walltime:-null}" >> outputs/log.txt
##mem=$(qstat -f -t | grep "${SLURM_JOBID}" | grep 'resources_used.mem' | awk -F ' = ' '{print $2}')
##echo "#### memory used by ${SLURM_JOBID} was: ${mem:-null}" >> outputs/log.txt
##vmmemory=$(qstat -f -t "${SLURM_JOBID}" | grep 'resources_used.vmem' | awk -F ' = ' '{print $2}')
##echo "#### vmemory used by ${SLURM_JOBID} was: ${vmmemory:-null}" >> outputs/log.txt
##cputime=$(qstat -f -t "${SLURM_JOBID}" | grep 'resources_used.cput' | awk -F ' = ' '{print $2}')
##echo "#### cputime used by ${SLURM_JOBID} was: ${cputime:-null}" >> outputs/log.txt
####qstat -f -t ${SLURM_JOBID} >> outputs/log.txt

