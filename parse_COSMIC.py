import re
import os
import sys
import pysam

file=pysam.FastaFile('/BIODATA/HD/common/NGS/fb_genome/genome.fa')

for line in sys.stdin:
	m=line.split('\t')
	if 'MT' == m[0]:
		continue
	m[0]='chr'+m[0]
	alt=m[4]
	alt=alt.replace('.','O')
	lref=len(m[3])
	lalt=len(alt)
	trim=0
	mx=range(0)
	if lalt < lref:
		mx=range(lalt);
	elif lref < lalt:
		mx=range(lref);
	for i in mx:
		if m[3][lref-i-1] == alt[lalt-i-1]:
			loc=m[0]+':'+ str(int(m[1])+lref-1)+'-'+str(int(m[1])+lref-1)
			base=file.fetch(region=loc)
			if base.strip() in m[3][lref-i-1]:
				trim=trim+1
			else:
				break
		else:
			break



	ref=m[3][0:lref-trim]
	alt=alt[0:lalt-trim]
	while len(alt) < len(ref):
		alt=alt+'O'
	while len(ref) < len(alt):
		ref=ref+'O'

	lalt=len(alt)
	lref=len(ref)
	alt1=''
	ref1=''
	i=0
#	print(alt,ref,'here1')
	while alt[i] == ref[i]:
		i=i+1
	alt1=alt[i:]
	ref1=ref[i:]
	#m[2]=str(int(m[2])+i)
	m[1]=str(int(m[1])+i)


	ref=ref1;
	alt=alt1;
#	print(ref,alt,m[1],m[2])
	lalt=len(alt)
	lref=len(ref)

	if alt=='O' and lalt ==1:
		loc=m[0]+':'+ str(int(m[1])-1)+'-'+str(int(m[1])-1)
		base=file.fetch(region=loc)
		while base.strip() == ref:
			#m[2]=str(int(m[2])-1)
			m[1]=str(int(m[1])-1)
#			print(m[2],m[1])
			loc=m[0]+':'+ str(int(m[1])-1)+'-'+str(int(m[1])-1)
			base=file.fetch(region=loc)

#	print(ref,alt,lref)
	if ref=='O' and lref == 1:
		loc=m[0]+':'+ str(int(m[1])-1)+'-'+str(int(m[1])-1)
		base=file.fetch(region=loc)
#		print(loc,base,'hello')
		while base.strip() == alt:
			#m[2]=str(int(m[2])-1)
			m[1]=str(int(m[1])-1)
#			print(loc,base)
			loc=m[0]+':'+ str(int(m[1])-1)+'-'+str(int(m[1])-1)
			base=file.fetch(region=loc)
	altf=''
	reff=''
	for i in range(len(ref)):
		#print(i)
		if alt[i] != ref[i]:
			altf=altf+alt[i]
			reff=reff+ref[i]
	variant= m[0] + '@' + m[1] + '@' + reff + '@' + altf
#	for i in range(len(reff)):
	print(m[0]+'\t'+str(int(m[1])-1)+'\t'+m[1]+'\t'+('@').join([m[0],str(int(m[1])),reff,altf,m[7].strip()])+';'+m[2])
