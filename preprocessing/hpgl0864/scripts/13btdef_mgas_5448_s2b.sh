#!/usr/bin/env bash
#SBATCH --export=ALL
#SBATCH --mail-type=NONE
#SBATCH --workdir=/cbcb/nelsayed-scratch/atb/tnseq/spyogenes_5448v3/preprocessing/hpgl0864
#SBATCH --partition=dpart
#SBATCH --qos=workstation
#SBATCH --nodes=1
#SBATCH --time=10:00:00
#SBATCH --job-name=btdef_mgas_5448_s2b
#SBATCH --mem=6G
#SBATCH --cpus-per-task=4
#SBATCH --output=/cbcb/nelsayed-scratch/atb/tnseq/spyogenes_5448v3/preprocessing/hpgl0864/outputs/btdef_mgas_5448_s2b.sbatchout

echo "####Started /cbcb/nelsayed-scratch/atb/tnseq/spyogenes_5448v3/preprocessing/hpgl0864/scripts/13btdef_mgas_5448_s2b.sh at $(date)" >> outputs/log.txt
cd /cbcb/nelsayed-scratch/atb/tnseq/spyogenes_5448v3/preprocessing/hpgl0864 || exit

## Converting the text sam to a compressed, sorted, indexed bamfile.
## Also printing alignment statistics to outputs/bowtie_mgas_5448/hpgl0864-def.bam.stats
## This job depended on: 545
samtools view -u -t /cbcbhomes/abelew/libraries/genome/mgas_5448.fasta \
    -S outputs/bowtie_mgas_5448/hpgl0864-def.sam -o outputs/bowtie_mgas_5448/hpgl0864-def.bam 1>outputs/bowtie_mgas_5448/hpgl0864-def.bam 2>&1 && \
  samtools sort -l 9 outputs/bowtie_mgas_5448/hpgl0864-def.bam -o outputs/bowtie_mgas_5448/hpgl0864-def-sorted.bam 2>outputs/bowtie_mgas_5448/hpgl0864-def-sorted.out 1>&2 && \
  rm outputs/bowtie_mgas_5448/hpgl0864-def.bam && \
  rm outputs/bowtie_mgas_5448/hpgl0864-def.sam && \
  mv outputs/bowtie_mgas_5448/hpgl0864-def-sorted.bam outputs/bowtie_mgas_5448/hpgl0864-def.bam && \
  samtools index outputs/bowtie_mgas_5448/hpgl0864-def.bam
## The following will fail if this is single-ended.
samtools view -b -f 2 -o outputs/bowtie_mgas_5448/hpgl0864-def-paired.bam outputs/bowtie_mgas_5448/hpgl0864-def.bam && \
  samtools index outputs/bowtie_mgas_5448/hpgl0864-def-paired.bam
bamtools stats -in outputs/bowtie_mgas_5448/hpgl0864-def.bam 2>outputs/bowtie_mgas_5448/hpgl0864-def.bam.stats 1>&2 && \
  bamtools stats -in outputs/bowtie_mgas_5448/hpgl0864-def-paired.bam 2>outputs/bowtie_mgas_5448/hpgl0864-def-paired.stats 1>&2

## The following lines give status codes and some logging
echo $? > outputs/status/btdef_mgas_5448_s2b.status
echo "###Finished ${SLURM_JOBID} 13btdef_mgas_5448_s2b.sh at $(date), it took $(( SECONDS / 60 )) minutes." >> outputs/log.txt

##walltime=$(qstat -f -t "${SLURM_JOBID}" | grep 'resources_used.walltime' | awk -F ' = ' '{print $2}')
##echo "#### walltime used by ${SLURM_JOBID} was: ${walltime:-null}" >> outputs/log.txt
##mem=$(qstat -f -t | grep "${SLURM_JOBID}" | grep 'resources_used.mem' | awk -F ' = ' '{print $2}')
##echo "#### memory used by ${SLURM_JOBID} was: ${mem:-null}" >> outputs/log.txt
##vmmemory=$(qstat -f -t "${SLURM_JOBID}" | grep 'resources_used.vmem' | awk -F ' = ' '{print $2}')
##echo "#### vmemory used by ${SLURM_JOBID} was: ${vmmemory:-null}" >> outputs/log.txt
##cputime=$(qstat -f -t "${SLURM_JOBID}" | grep 'resources_used.cput' | awk -F ' = ' '{print $2}')
##echo "#### cputime used by ${SLURM_JOBID} was: ${cputime:-null}" >> outputs/log.txt
####qstat -f -t ${SLURM_JOBID} >> outputs/log.txt

