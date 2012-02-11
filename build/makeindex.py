import re
import glob
import os
import fileinput

apis = glob.glob('..\\config\\*ELDAConfig.ttl')
apidata = ""

template = re.compile('''api:uriTemplate.*?"(.*?)"''')
comment = re.compile('''rdfs:comment.*?"(.*?)"''')
exampleRequestPath = re.compile('''api:exampleRequestPath.*?"(.*?)"''')
endSection = re.compile('''\.''')
startSection = re.compile('''a api:(Item|List)Endpoint''')

relativePath = "./api"

for file in apis:
    endpoints = {}
    data = open (file, 'r').readlines()
        
    apidata += "<h2>%s</h2>" % file.split('\\')[2]
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
