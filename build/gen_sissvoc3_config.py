import ConfigParser,os,sys
Config = ConfigParser.ConfigParser()


if(len(sys.argv) <= 1):
   print "\n\tusage: python gen_sissvoc3_config.py <output file>\n"

print "Initialising..."

Config.read('config.properties')
filename='SISSvoc3-ELDAConfig-template.ttl'
infile = open(filename)

outfilename = sys.argv[1]
outfile = open(outfilename, 'w')

print "Emitting to file: ", outfilename

for line in infile:
   for key in Config.options('settings'):
      textToSearch = '%' + key.upper() + '%'
      textToReplace = Config.get('settings',key) 
      line = line.replace(textToSearch, textToReplace)

   outfile.write(line)

infile.close()
outfile.close()
print "Done!"
