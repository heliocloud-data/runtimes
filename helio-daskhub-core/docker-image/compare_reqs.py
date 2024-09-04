filename1 = "requirements.txt.orig"
filename2 = "requirements_pyhc.txt"

with open (filename1, 'r') as f:
    reqs = [v.split('=')[0].split('>')[0].strip() for v in f.readlines()] 
r1 = set (reqs)

with open (filename2, 'r') as f:
    reqs = [v.split('=')[0].split('>')[0].strip() for v in f.readlines()] 
r2 = set (reqs)

print (f'items in {filename1} but not {filename2}')
print(r1 - r2)

print (f'items in {filename2} but not {filename1}')
print(r2 - r1)
