# !/bin/sh

# Usage: mutation-call-annotation.sh (PREFIX).simplerepeat_mutations.txt

# HGVD annotations
if [ _${ACTIVE_HGVD_2016_FLAG} = "_True" ]; then 
    mutanno mutation -t $1 -o ${OUTPUT_PREF}.HGVD_2016.txt -d ${ANNOTATION_DB}/DBexome20160412.bed.gz -c 5
else
    cp ${OUTPUT_PREF}.simplerepeat_mutations.txt ${OUTPUT_PREF}.HGVD_2016.txt
fi
# ExAC annotations
if [ _${ACTIVE_EXAC_FLAG} = "_True" ]; then 
    mutanno mutation -t ${OUTPUT_PREF}.HGVD_2016.txt -o ${OUTPUT_PREF}.ExAC.txt -d ${ANNOTATION_DB}/ExAC.r0.3.1.sites.vep.bed.gz -c 8
else
    cp ${OUTPUT_PREF}.HGVD_2016.txt ${OUTPUT_PREF}.ExAC.txt
fi

cp ${OUTPUT_PREF}.ExAC.txt ${OUTPUT_PREF}.mutations_candidate.txt

# Add header
mut_header=""
if [ _${SAMPLE2_FLAG} = "_False" ]
then
    mut_header="Chr,Start,End,Ref,Alt,depth,variantNum,bases,A_C_G_T,misRate,strandRatio,10%_posterior_quantile,posterior_mean,90%_posterior_quantile,readPairNum,variantPairNum,otherPairNum,10%_posterior_quantile(realignment),posterior_mean(realignment),90%_posterior_quantile(realignment),simple_repeat_pos,simple_repeat_seq,P-value(EBCall)"
else
    mut_header="Chr,Start,End,Ref,Alt,depth_tumor,variantNum_tumor,depth_normal,variantNum_normal,bases_tumor,bases_normal,A_C_G_T_tumor,A_C_G_T_normal,misRate_tumor,strandRatio_tumor,misRate_normal,strandRatio_normal,P-value(fisher),score(hotspot),readPairNum_tumor,variantPairNum_tumor,otherPairNum_tumor,readPairNum_normal,variantPairNum_normal,otherPairNum_normal,P-value(fisher_realignment),indel_mismatch_count,indel_mismatch_rate,bp_mismatch_count,distance_from_breakpoint,simple_repeat_pos,simple_repeat_seq,P-value(EBCall)"
fi

if [ _${CONTROL_BAM_FLAG} = "_False" ]
then
    mut_header=`echo ${mut_header} | awk -F"," -v OFS="," '{{$NF=""; sub(/.$/,""); print $0}}'`
fi

tmp_header=`echo $mut_header | tr "," "\t"`
print_header=${tmp_header}

if [ _${ACTIVE_HGVD_2016_FLAG} = "_True" ]
then
    HGVD_header="HGVD_20160412:#Sample,HGVD_20160412:Filter,HGVD_20160412:NR,HGVD_20160412:NA,HGVD_20160412:Frequency(NA/(NA+NR))"
    tmp_header=`echo $HGVD_header | tr "," "\t"`
    print_header=${print_header}"\t"${tmp_header}
fi
if [ _${ACTIVE_EXAC_FLAG} = "_True" ]
then
    ExAC_header="ExAC:Filter,ExAC:AC_Adj,ExAC:AN_Adj,ExAC:Frequency(AC_Adj/AN_Adj),ExAC:AC_POPMAX,ExAC:AN_POPMAX,ExAC:Frequency(AC_POPMAX/AN_POPMAX),ExAC:POPMAX"
    tmp_header=`echo $ExAC_header | tr "," "\t"`
    print_header=${print_header}"\t"${tmp_header}
fi

echo "$META" > ${OUTPUT_PREF}.genomon_mutation.result.txt
echo "$print_header" >> ${OUTPUT_PREF}.genomon_mutation.result.txt
cat ${OUTPUT_PREF}.mutations_candidate.txt >> ${OUTPUT_PREF}.genomon_mutation.result.txt
