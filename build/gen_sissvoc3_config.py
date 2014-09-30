import ConfigParser,os,sys
Config = ConfigParser.ConfigParser()

import argparse

parser = argparse.ArgumentParser(description='Process some integers.')
parser.add_argument('--config', help='config file (default is config.properties)', type=str, default='config.properties')
parser.add_argument('outputfile', help='output file', type=str)

args = parser.parse_args()



print "Initialising..."

if args.config:
   configfile = args.config
else:
   configfile = 'config.properties'
   

Config.read(configfile)
filename='SISSvoc3-ELDAConfig-template.ttl'
infile = open(filename)

outfilename = args.outputfile
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
