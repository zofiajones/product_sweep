ROOT="~/endogenous_variants"
cd $ROOT"/results/"$1

grep COSM potential_found_count.vcf > 1_cust_COSM_single_allele_exome.vcf
grep COSM potential_found_count.vcf | awk '{print $4}' | awk -F ',' '{print $2}' | sort | uniq > found_gene.txt
grep -vf found_gene.txt genes.txt > 1_cust_COSM_single_allele_exome_missed_genes.txt

echo -e "1\t"$(awk '{for (i=1;i<=NF;i++) {printf "%s\t",$i}}' found_gene.txt )"\tnot found\t"$(awk '{for (i=1;i<=NF;i++) {printf "%s\t",$i}}'  1_cust_COSM_single_allele_exome_missed_genes.txt) >> all_genes_found.txt

cat potential_found_count.vcf | grep -v COSM  > 2_cust_single_allele_exome.vcf
cat potential_found_count.vcf | grep -v COSM  | awk '{print $4}' | awk -F ',' '{print $2}' | sort | uniq > found_gene.txt
cat potential_found_count.vcf  | awk '{print $4}' | awk -F ',' '{print $2}' | sort | uniq
grep -vf found_gene.txt genes.txt > 2_cust_single_allele_exome_missed_genes.txt

echo -e "2\t"$(awk '{for (i=1;i<=NF;i++) {printf "%s\t",$i}}' found_gene.txt )"\tnot found\t"$(awk '{for (i=1;i<=NF;i++) {printf "%s\t",$i}}' 2_cust_single_allele_exome_missed_genes.txt) >> all_genes_found.txt

echo "here"

grep COSM output_not_cust.vcf | awk '{print $3}' | awk -F ',' '{print $2}' | sort | uniq > found_gene.txt
grep COSM output_not_cust.vcf  > 3_COSM_single_exome.vcf
grep -vf found_gene.txt genes.txt > 3_COSM_single_exome_missed_genes.txt

echo -e "3\t"$(awk '{for (i=1;i<=NF;i++) {printf "%s\t",$i}}' found_gene.txt )"\tnot found\t"$(awk '{for (i=1;i<=NF;i++) {printf "%s\t",$i}}' 3_COSM_single_exome_missed_genes.txt ) >> all_genes_found.txt

cat output_not_cust.vcf  | grep -v COSM | awk '{print $3}' | awk -F ',' '{print $2}' | sort | uniq > found_gene.txt
cat output_not_cust.vcf | grep -v COSM > 4_single_exome.vcf
grep -vf found_gene.txt genes.txt > 4_single_exome_missed_genes.txt

echo -e "4\t"$(awk '{for (i=1;i<=NF;i++) {printf "%s\t",$i}}' found_gene.txt )"\tnot found\t"$(awk '{for (i=1;i<=NF;i++) {printf "%s\t",$i}}' 4_single_exome_missed_genes.txt )  >> all_genes_found.txt

cat output_found.vcf  | awk '{print $3}' | awk -F ',' '{print $2}' | sort | uniq  > found_gene.txt
cat output_found.vcf > 5_exome.vcf
grep -vf found_gene.txt genes.txt > 5_exome_missed_genes.txt

echo -e "5\t"$(awk '{for (i=1;i<=NF;i++) {printf "%s\t",$i}}' found_gene.txt )"\tnot found\t"$(awk '{for (i=1;i<=NF;i++) {printf "%s\t",$i}}' 5_exome_missed_genes.txt )  >> all_genes_found.txt

echo "here1"

awk '{print $5}' potential_found_count.vcf | grep  '\.' > pot_indel.vcf
awk '{print $4}' output_found.vcf | grep  '\.' > out_indel.vcf

awk '{print $6}' potential_found_count.vcf | grep  '\.' > pot_del.vcf
awk '{print $5}' output_found.vcf | grep  '\.' > out_del.vcf


#echo -e "1_cust_COSM\t"$(cat 1_cust_COSM_single_allele_exome.vcf | wc -l) > sorted_count.txt
#echo -e "2_cust_single\t"$(cat 2_cust_single_allele_exome.vcf  | wc -l) >> sorted_count.txt
#echo -e "3_COSM_single\t"$(cat 3_COSM_single_exome.vcf | wc -l) >> sorted_count.txt
#echo -e  "4_single_exome\t"$(cat 4_single_exome.vcf  | wc -l) >> sorted_count.txt


a=$(awk '{print $1}' 1_cust_COSM_single_allele_exome.vcf | sort | uniq | wc -l)
b=$(awk '{print $1}' 2_cust_single_allele_exome.vcf | sort | uniq | wc -l)
c=$(awk '{print $1}' 3_COSM_single_exome.vcf  | sort | uniq | wc -l)
d=$(awk '{print $1}' 4_single_exome.vcf | sort | uniq | wc -l)
e=$(awk '{print $1}' output_found_index.vcf | sort | uniq | wc -l)

echo -e "1_cust_COSM\t"$a > sorted_count.txt
echo -e "2_cust_single\t"$b >> sorted_count.txt
echo -e "3_COSM_single\t"$c >> sorted_count.txt
echo -e  "4_single_exome\t"$d >> sorted_count.txt
echo -e "total variants\t"$e >> sorted_count.txt

echo -e "1_genes_count\t"$(awk '{print $4}' 1_*.vcf | awk -F ',' '{print $2}'  | sort | uniq -c | sort -nrk1 | wc -l) > genes_count.txt
echo -e "2_genes_count\t"$(awk '{print $4}' 2_*.vcf | awk -F ',' '{print $2}'  | sort | uniq -c | sort -nrk1 | wc -l) >> genes_count.txt
echo -e "3_genes_count\t"$(awk '{print $4}' 3_*.vcf | awk -F ',' '{print $2}' | sort | uniq -c | sort -nrk1 | wc -l) >> genes_count.txt
echo -e "4_genes_count\t"$(awk '{print $4}' 4_*.vcf | awk -F ',' '{print $2}' | sort | uniq -c | sort -nrk1 | wc -l) >> genes_count.txt

awk '{print $4}' 1_*.vcf  | awk -F ',' '{print $2}'  > gene_list.txt
awk '{print $4}' 2_*.vcf  | awk -F ',' '{print $2}'  >> gene_list.txt
awk '{print $4}' 3_*.vcf  | awk -F ',' '{print $2}' >> gene_list.txt
awk '{print $4}' 4_*.vcf  | awk -F ',' '{print $2}' >> gene_list.txt

#echo -e "total_uniq_genes\t"$(cat gene_list.txt  | sort | uniq -c | sort -nrk1 | wc -l) >> genes_count.txt

echo -e "total_output_found\t"$(awk '{print $4}' output_found_index.vcf  | awk -F ',' '{print $2}' | sort | uniq -c | sort -nrk1 | wc -l) >> genes_count.txt

rm indels.vcf
while read p;do
str=($p)
ref=${str[4]}
alt=${str[5]}

#echo ${#ref}
#echo ${#alt}

if [[ ${#ref} != ${#alt} ]];then
echo $p >> indels.vcf
fi
done < potential_found_count.vcf

while read p;do
str=($p)
ref=${str[3]}
alt=${str[4]}

#echo ${#ref}
#echo ${#alt}

if [[ ${#ref} != ${#alt} ]];then
echo $p >> indels.vcf
fi

done < output_found.vcf

cd $ROOT/scripts/product_sweep/
