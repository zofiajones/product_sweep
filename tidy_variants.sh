ROOT="/home/zjones/endogenous_variants/"
DIR=$ROOT"/results/"$1
cd $DIR
SOURCE=$ROOT"/scripts/product_sweep/"

rm list.vcf
rm list.bed
while read p;do

#echo $p
ls  ""hd*"$p".txt""
for i in $(ls ""hd*"$p".txt"");do

echo "check\t"$i
echo $i

j=$(echo $i | awk -F '_' '{print $1}')
par=$( basename $j)
gene=$p
info=$par","$gene

echo $info

echo $i
cat $i | python $SOURCE/parse_multi_fb.py $info >> list.vcf
cat $i | python $SOURCE/parse_multi_fb.py $info | awk 'BEGIN{OFS="\t"}{print $1,$2-1,$2,$3,$4,$5,$6}'  >> list.bed

done
done < genes_1.txt


awk 'BEGIN{OFS=""}{print $1,":",$2,"-",$2}' list.vcf > gloc.txt
awk 'BEGIN{OFS=""}{print $4,$5}' list.vcf > bc_1.txt

paste -d '\t' gloc.txt bc_1.txt > gloc_bc.txt

rm found.txt
while read p;do

par0=$(echo $p | awk '{print $2}'| awk -F ',' '{print $1}')

found=""
for i in $(ls ""hd*fb.vcf.gz"" );do

j=$(basename $i)
par=$(echo $j | awk -F '_' '{print $1}')

check=$($ROOT/bin/tabix $i $p | grep -vP 'AB=[0,];' | wc -l)
bc=$(~/hb/tools/tabix $i $p | python $SOURCE/parse_multi_fb.py "info" |  awk 'BEGIN{OFS=""}{print $4,$5}' )

echo "check"

if [[ $check > 0  ]];then

bcref=$(grep $p gloc_bc.txt| awk '{print $2}' | sort | uniq )

echo -e "check\t"$check

echo -e "bc\t"$bc

echo -e "bcref\t"$bcref

if [[ $bc == $bcref ]];then

#echo "found"
found=$found","$par

else

found=$found",not-"$par

if [[ $par == $par0  ]];then

found=$found",multi-allelic"

fi

fi

fi

done

echo "found\t"$found
echo $found >> found.txt

done < gloc.txt

paste -d '\t' output_gene_hg19_PASS.vcf found.txt > output_found.vcf

awk 'BEGIN{OFS=""}{print $1,"@",$2,"@",$4,"@",$5}' output_found.vcf > output_found_loc.vcf

paste -d '\t' output_found_loc.vcf output_found.vcf > output_found_index.vcf

cp $ROOT/results/request_end/potential_all.txt .
grep -vP '\t0\.0,'  potential_all.txt | grep -vP '\t0,' > potential_all_1.txt

#awk 'BEGIN{OFS=""}{print $1,"@",$3,"@",$4,"\t",$5,"\t",$6}' potential.vcf > potential_loc_count.vcf

awk 'BEGIN{OFS=""}{print $1}' potential_all_1.txt > potential_loc.vcf

grep -f potential_loc.vcf  output_found_index.vcf > potential_found.vcf
grep -f potential_loc.vcf  output_found_index.vcf | awk '{print $1}' > potential_found_loc.vcf

grep -vf potential_found_loc.vcf output_found_index.vcf | awk 'BEGIN{OFS="\t"}{for (i=1;i<=NF;i++){printf "%s\t",$i}printf "\n"}' > output_not_cust.vcf

rm potential_count.vcf
while read p;do
grep $p  potential_all_1.txt  | awk '{print $2,$3}' >> potential_count.vcf

done < potential_found_loc.vcf

paste -d '\t' potential_found.vcf potential_count.vcf > potential_found_count.vcf

rm cust_count.txt
rm count.txt
rm COSMIC_count.txt
rm COSMIC_cust_count.txt

while read p;do

a=$(grep $p potential_found_count.vcf | wc -l)
b=$(grep $p output_found.vcf | wc -l)
c=$(grep $p potential_found_count.vcf | grep COSM | wc -l)
d=$(grep $p output_found.vcf | grep COSM | wc -l)

echo -e $p"\t"$a >> cust_count.txt
echo -e $p"\t"$b >> count.txt
echo -e $p"\t"$c >> COSMIC_cust_count.txt
echo -e $p"\t"$d >> COSMIC_count.txt

done < genes_1.txt

