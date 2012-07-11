import re
import fnmatch
import os
import fileinput

if ('WEB-INF' in os.listdir('.')):
	basedir='.'
else:
	basedir='..' + os.sep

print "Searching for configs here: %s" % (basedir)
	
apis = []
for root, dirnames, filenames in os.walk(basedir):
  for filename in fnmatch.filter(filenames, '*ELDAConfig.ttl'):
      apis.append(root + os.sep + filename)

apidata = ""

template = re.compile('''api:uriTemplate.*?"(.*?)"''')
comment = re.compile('''rdfs:comment.*?"(.*?)"''')
exampleRequestPath = re.compile('''api:exampleRequestPath.*?"(.*?)"''')
endSection = re.compile('''\.''')
startSection = re.compile('''a api:(Item|List)Endpoint''')

relativePath = "./api"

for file in sorted(apis):
    print "Found config file: %s" % (file)
    endpoints = {}
    data = open (file, 'r').readlines()

    apidata += "<h2><a href='%s'>%s</a></h2>" % (file.split(os.sep, 1)[1], file.split(os.sep, 1)[1])
    apidata += "<table><tr><th>Description</th><th>Template</th><th>Sample URI</th>"
    lookHarder = False
    for line in data:
        if startSection.search(line):
            lookHarder = True
        if lookHarder:
            if template.search(line):
                endpoints['template'] = template.search(line).group(1)
            if comment.search(line):
                endpoints['comment'] = comment.search(line).group(1)
            if exampleRequestPath.search(line):
                endpoints['request'] = exampleRequestPath.search(line).group(1)
            if endSection.search(line):
                lookHarder = False
                apidata += "<tr><td>%s</td><td><pre>%s</pre></td><td><a href=%s%s>%s%s</a></td></tr>\n"  % \
                    (endpoints['comment'], endpoints['template'], relativePath, endpoints['request'], relativePath, endpoints['request'])
  
    apidata += "</table><hr/><br/>"

for line in fileinput.input("verbose.html", inplace = 1): 
      print line.replace("<!-- REPLACE ME -->", apidata),
