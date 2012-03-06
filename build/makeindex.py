import re
import os
import fileinput
import fnmatch


html_top = '''<html>
<head>
<title>Elda -- an implementation of the Linked Data API</title>
<link href="style.css" type="text/css" rel="stylesheet"></link>
</head>
<body>
<div class="main">
<div class="heading">
<a href="http://www.epimorphics.com">
<img class="logo" src="epilogo-240.png">
</a>
<h1>Elda - %BUILDNUMBER%</h1>
<h2>An implementation of the Linked Data API</h2>
</div>
<h4>RESTful vocabulary-service interface, following the Linked Data API.</h4>
<h1>
URI Templates Available :
</h1>
<menu>
'''

html_bottom = '''
</menu>
<p><i>Re-Engineering the SISSVoc Using Linked Data API :</i></p><a href = "https://www.seegrid.csiro.au/wiki/bin/view/Siss/VocabularyService3"> For detailed documentation click here:</a>
</body>
</html>'''

apis = []
for root, dirnames, filenames in os.walk('..'+os.sep):
  for filename in fnmatch.filter(filenames, '*ELDAConfig.ttl'):
      apis.append(root + os.sep + filename)
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
    nicefile = '/'.join(file.split(os.sep)[1:])
    apidata += "<h2><a href='%s'>%s</a></h2>" % (nicefile, nicefile)
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

outputfile = open("verbose.html", 'w')
outputfile.write(html_top + apidata + html_bottom)
outputfile.close()
