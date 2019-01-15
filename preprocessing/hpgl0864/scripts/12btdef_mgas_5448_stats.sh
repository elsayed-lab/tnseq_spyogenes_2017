#!/usr/bin/env bash
#SBATCH --export=ALL
#SBATCH --mail-type=NONE
#SBATCH --workdir=/cbcb/nelsayed-scratch/atb/tnseq/spyogenes_5448v3/preprocessing/hpgl0864
#SBATCH --partition=dpart
#SBATCH --qos=workstation
#SBATCH --nodes=1
#SBATCH --time=10:00:00
#SBATCH --job-name=btdef_mgas_5448_stats
#SBATCH --mem=6G
#SBATCH --cpus-per-task=4
#SBATCH --output=/cbcb/nelsayed-scratch/atb/tnseq/spyogenes_5448v3/preprocessing/hpgl0864/outputs/btdef_mgas_5448_stats.sbatchout

echo "####Started /cbcb/nelsayed-scratch/atb/tnseq/spyogenes_5448v3/preprocessing/hpgl0864/scripts/12btdef_mgas_5448_stats.sh at $(date)" >> outputs/log.txt
cd /cbcb/nelsayed-scratch/atb/tnseq/spyogenes_5448v3/preprocessing/hpgl0864 || exit

## This is a stupidly simple job to collect alignment statistics.

if [ ! -r "outputs/bowtie_stats.csv" ]; then
  echo "name,type,original_reads,reads,one_hits,failed,samples,rpm,count_table" > outputs/bowtie_stats.csv
fi
original_reads_tmp=$(grep "^Input Reads" outputs/hpgl0864-trimomatic.out | awk '{print $3}' | sed 's/ //g')
original_reads=${original_reads_tmp:-0}
reads_tmp=$(grep "^# reads processed" outputs/bowtie_mgas_5448/hpgl0864-def.err | awk -F: '{print $2}' | sed 's/ //g')
reads=${reads_tmp:-0}
one_align_tmp=$(grep "^# reads with at least one reported" outputs/bowtie_mgas_5448/hpgl0864-def.err | awk -F": " '{print $2}' | sed 's/ .*//g')
one_align=${one_align_tmp:-0}
failed_tmp=$(grep "^# reads that failed to align" outputs/bowtie_mgas_5448/hpgl0864-def.err | awk -F": " '{print $2}' | sed 's/ .*//g')
failed=${failed_tmp:-0}
sampled_tmp=$(grep "^# reads with alignments sampled" outputs/bowtie_mgas_5448/hpgl0864-def.err | awk -F": " '{print $2}' | sed 's/ .*//g')
sampled=${sampled_tmp:-0}
rpm_tmp=$(perl -e "printf(1000000 / ${one_align})" 2>/dev/null)
rpm=${rpm_tmp:-0}
stat_string=$(printf "hpgl0864,def,%s,%s,%s,%s,%s,%s,hpgl0864-def.count.xz" "${original_reads}" "${reads}" "${one_align}" "${failed}" "${sampled}" "$rpm")
echo "$stat_string" >> outputs/bowtie_stats.csv
## The following lines give status codes and some logging
echo $? > outputs/status/btdef_mgas_5448_stats.status
echo "###Finished ${SLURM_JOBID} 12btdef_mgas_5448_stats.sh at $(date), it took $(( SECONDS / 60 )) minutes." >> outputs/log.txt

##walltime=$(qstat -f -t "${SLURM_JOBID}" | grep 'resources_used.walltime' | awk -F ' = ' '{print $2}')
##echo "#### walltime used by ${SLURM_JOBID} was: ${walltime:-null}" >> outputs/log.txt
##mem=$(qstat -f -t | grep "${SLURM_JOBID}" | grep 'resources_used.mem' | awk -F ' = ' '{print $2}')
##echo "#### memory used by ${SLURM_JOBID} was: ${mem:-null}" >> outputs/log.txt
##vmmemory=$(qstat -f -t "${SLURM_JOBID}" | grep 'resources_used.vmem' | awk -F ' = ' '{print $2}')
##echo "#### vmemory used by ${SLURM_JOBID} was: ${vmmemory:-null}" >> outputs/log.txt
##cputime=$(qstat -f -t "${SLURM_JOBID}" | grep 'resources_used.cput' | awk -F ' = ' '{print $2}')
##echo "#### cputime used by ${SLURM_JOBID} was: ${cputime:-null}" >> outputs/log.txt
####qstat -f -t ${SLURM_JOBID} >> outputs/log.txt

