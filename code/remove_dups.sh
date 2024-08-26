#!/usr/bin/bash
set -ex

source ./config.sh

echo "Number of Bam Files: $file_count"
echo "Using $num_threads Threads"

filter_string=""

if [ $min_read_quality -gt 0  ]; then
    filter_string="mapping_quality >= ${min_read_quality}"
    if [ $filter_unaligned == "True" ] || [ $filter_multimappers == "True" ]; then
        filter_string=$filter_string" and "
    fi
fi

if  [ $filter_unaligned == "True" ] && [ $filter_multimappers == "True" ]; then
    filter_string=$filter_string"not (unmapped or secondary_alignment or mate_is_unmapped) and not ([XA] != null)"
elif [ $filter_unaligned == "True" ]; then
    filter_string=$filter_string"not (unmapped or mate_is_unmapped)"
elif [ $filter_multimappers == "True" ]; then
    filter_string=$filter_string"not (secondary_alignment) and not ([XA] != null)"
fi

echo "Filter String : $filter_string"

if [ "$file_count" -gt 0 ]; 
then

    for bamfile in ${bamfiles};
    do  

        prefix=$(basename -s .bam $bamfile)
        mkdir -p "../scratch/${prefix}"
        mkdir -p "../results/${prefix}"

        cp $bamfile "../scratch/${prefix}/${prefix}.tmp.bam"
        
        NOT_SORTED=0
        sambamba index "../scratch/${prefix}/${prefix}.tmp.bam" || NOT_SORTED=$?

        if [ $NOT_SORTED != 0 ] && [ $filter_dups == "True" ];
        then

            echo "Bam file is not coordinate sorted"
            echo "Starting sort"

            sambamba sort \
            -t "${num_threads}" \
            -l ${compress_int} \
            --tmpdir="${temp_dir}" \
            -o "../scratch/${prefix}/${prefix}.tmp2.bam" \
            "../scratch/${prefix}/${prefix}.tmp.bam"
            
            echo "Finished sorting."

        else
            cp "../scratch/${prefix}/${prefix}.tmp.bam" "../scratch/${prefix}/${prefix}.tmp2.bam"
        fi

        if [ $filter_dups == "True" ]; then

            sambamba markdup \
            -t "${num_threads}" \
            -l "${compress_int}" \
            ${remove} \
            --tmpdir="${temp_dir}" \
            "../scratch/${prefix}/${prefix}.tmp2.bam" \
            "../scratch/${prefix}/${prefix}.tmp3.bam"

        else
            cp "../scratch/${prefix}/${prefix}.tmp2.bam" "../scratch/${prefix}/${prefix}.tmp3.bam"
        fi

        if [ $filter_unaligned == "True" ] || [ $filter_multimappers == "True" ] || [ $min_read_quality -gt 0 ]; 
        then 

            sambamba view \
            -t $num_threads \
            -h \
            -f bam \
            -F "$filter_string" \
            -o "../results/${prefix}/${prefix}.bam" \
            "../scratch/${prefix}/${prefix}.tmp3.bam"
            
        else
            mv "../scratch/${prefix}/${prefix}.tmp3.bam" "../results/${prefix}/${prefix}.bam"
        fi

        echo "Building index"

        NOT_SORTED=0

        sambamba index \
        -t "${num_threads}" \
        "../results/${prefix}/${prefix}.bam" || NOT_SORTED=$?

        if [ $NOT_SORTED != 0 ];
        then
            echo "../results/${prefix}/${prefix}.bam not sorted, no index generated"
            rm ../results/${prefix}/${prefix}.bam.bai
        else
            echo "Finished Indexing"
        fi

        echo "Corrections are Complete"

    done
else
    echo "No Bam Files Were Found."
fi
