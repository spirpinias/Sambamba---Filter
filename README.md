# Mark or Remove Optical and PCR Duplicates in Illumina data using Sambamba

This capsule requires alignment files in bam format. Sambamba can filter out poor mapping quality, duplicates, secondary/multimapped and unmapped reads from your alignment file. It will return your processed bam file to the results folder.

[Documentation](https://lomereiter.github.io/sambamba/docs/sambamba-markdup.html)

## Inputs

**\*.bam** files in the **/data** directory.

## Outputs

.bam files in individual folders (optionally sorted with index files)

## App Panel Parameters

Number of Threads
- Number of threads reserved for sambamba. If not selected, will use maximum available [Default: none]

Remove or mark duplicates
- Determines whether duplicates are fully removed from the .bam file or whether they are just marked. [Default: mark]

Compression
- specify compression level of the resulting file (from 0 to 9) [Default: 5]

## Auxiliary Parameters

Filter Duplicates
- Remove optical and PCR duplicates from alignment data. [Default: True]

Filter Unaligned Reads
- Remove reads which are not aligned or (for paired end data) reads whose mate pair is not aligned [Default: False]

Filter Multimappers
- Filter secondary alignments and (for paired end data) single ended [Default: False] 

Min Read Mapping
- Filter reads below this MAPQ score [Default: 0]

## Other Notes

This capsule is an alternative to ```samtools markdup``` and ```picard markduplicates```. Removing duplicates requires the .bam to be sorted, if an input file is not already sorted it will be before removing duplicates. 

## Source 

https://github.com/biod/sambamba

## Cite

```A. Tarasov, A. J. Vilella, E. Cuppen, I. J. Nijman, and P. Prins. Sambamba: fast processing of NGS alignment formats. Bioinformatics, 2015.```
