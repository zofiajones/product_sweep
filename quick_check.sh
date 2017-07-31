ROOT="/home/zjones/endogenous_variants/"
DIR=$ROOT"/results/"$1
mkdir $DIR
cd $DIR

awk 'BEGIN{OFS=""}{print "chr",$1,":",$2+1,"-",$3+1}' $ROOT/NCBI_bed/gene.bed > gene_targets.txt
awk '{print $4}' $ROOT/NCBI_bed/gene.bed | grep -oP 'GENE=[A-Z 0-9]+' | grep -oP '[A-Z 0-9]+' | grep -v GENE > genes.txt
sort genes.txt | uniq > genes_1.txt
paste -d '\t' gene_targets.txt genes.txt > genes_targets.txt
sed 's/^/chr/g' $ROOT/NCBI_bed/gene.bed > gene_1.bed


for i in $(ls $ROOT/Product_Data/freebayes/*fb.vcf.gz);do

k=$( basename $i)
j=$DIR${k%_fb.vcf.gz}

while read p;do
echo "" > $j"_"${arr[1]}".txt"
done < genes_targets.txt

while read p;do

arr=($p)
echo ${arr[0]}
echo ${arr[1]}

$ROOT/bin/tabix $i ${arr[0]} | grep -vP 'AB=[0,]+;' | grep -v 'AB=0,0;' > found.txt
head found.txt
while read q;do

test0=$(echo $q | sed -n -e 's/.*SAF=\([0-9,]\+\).*SAR=\([0-9,]\+\);.*/\1 \2/p' | awk '{ if ($1>0 && $2>0){ print "1"  } else {print"0"}}' )
test3=$(echo $q | sed -n -e 's/.*DP=\([0-9,\.]\+\).*/\1/p' | awk '{ if ($1>100){ print "1"  } else {print "0"}}' )
test=$(( $test0 + $test3 ))

if [[ $test == 2 ]] ;then
echo $q >> $j"_"${arr[1]}".txt"
fi

done < found.txt



done < genes_targets.txt

done

cd $ROOT/scripts/product_sweep/
