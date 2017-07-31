import re
import os
import sys
import argparse
import tabix

info1=sys.argv[1]
tb=tabix.open('/home/zjones/COSMIC/CosmicCoding_sort.bed.gz')

for line in sys.stdin:
#	print(line)
	m=line.split()
	if len(m)<10:
		continue
	alt=m[4].split(',')
	tags=m[8].split(':')
	ind=tags.index('AD')
	AD=m[9].split(':')[ind].split(',')
	ind1=tags.index('DP')
	DP=m[9].split(':')[ind1]
	total_reads=0
	freq=[]
	for i in range(len(AD)):
		total_reads=total_reads+float(AD[i])
	if total_reads > 0:
		for i in range(1,len(AD)):
			freq.append(float(AD[i])/total_reads)
	j=freq.index(max(freq))
	print(m[0],int(m[1])-1 ,int(m[1]))
	records=tb.query(m[0],int(m[1])-1 ,int(m[1]))
	info=';'
	for record in records:
#		print(record)
		if (record[0]==m[0]) &  (record[2]==m[1]):
			n=record[3].split('@')
			if (n[2]==m[3]) & (n[3]==alt[j]):
				info=info+record[3].split('@')[-1].replace('GENE=','').replace('STRAND=','').replace('CDS=','').replace('AA=','').replace('CNT=','')+';'
	print(('\t').join([m[0],m[1],info1,m[3],alt[j],".","PASS",str(freq[j])+','+DP , info]) )
