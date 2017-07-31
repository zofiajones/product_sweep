import re
import sys

#file1=open('out_variants_sort.txt','r')
#lines=file1.readlines()
file2=open('out_variants_match.vcf','w')

for line in sys.stdin:
	#print(line)
	cols=line.split('\t')
	our_ref=cols[3]
	our_alt=cols[4]
	info=cols[7].split(';')
	refs=[]
	alts=[]
	info_keep=''
	for m in info:
		if 'c.' in m and '?' not in m:
			n=m.split(',')
			#print(n)
			p=n[0].replace('c.','').replace('\d+','')
			if '>' in p:
				n0=p.split('>')
				m0=re.search('([A-Z]+)',n0[0])
				#print(n)
				ref=m0.group(1)
				#print(ref)
				alt=n0[1]
			elif 'del' in p:
				#print('del',p)
				n0=p.split('del')
				#print(n0)
				ref=n0[1]
				alt='.'
			elif 'ins' in p:
				n0=p.split('_')
				#loc=n0[0]
				#print(n0)
				n1=n0[1].split('ins')
				ref='.'
				alt=n1[1]
			if '-' in n[2]:
				new_ref=''
				for i in ref:
					if 'C' in i:
						new=i.replace('C','G')
					if 'A' in i:
						new=i.replace('A','T')
					if 'G' in i:
						new=i.replace('G','C')
					if 'T' in i:
						new=i.replace('T','A')
					new_ref = new + new_ref
				ref=new_ref
				new_alt=''
				for i in alt:
					if 'C' in i:
						new=i.replace('C','G')
					if 'A' in i:
						new=i.replace('A','T')
					if 'G' in i:
						new=i.replace('G','C')
					if 'T' in i:
						new=i.replace('T','A')
				new_alt = new + new_alt
				alt=new_alt
				if not alt:
					alt='.'
				if not ref:
					ref='.'
			#print(ref,our_ref,alt,our_alt)
			if (our_ref == ref) & (our_alt == alt):
				found=1
				info_keep=info_keep + ';' + m.strip()
				#print('found',line)
			#else:
				#print('not found',line)
			alts.append(alt)
			refs.append(ref)
		if 'c.' not in m:
			info_keep = info_keep + m.strip()
	print(('\t').join(cols[:7]) + '\t' + info_keep + ';' + '\n')

#file1.close()
file2.close()
