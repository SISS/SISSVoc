# Spatial Information Services Stack Vocabulary Service (SISSVoc)

[![Build Status](https://travis-ci.org/SISS/SISSVoc.svg?branch=master)](https://travis-ci.org/SISS/SISSVoc)

Updated: 7 Feb 2019

Contact: Jonathan Yu (jonathan.yu [ at ] csiro.au)


## About

A minimal config package for setting up sissvoc.

### What's new?

* automated build via travis
* docker-compose deployment option
* build scripts included
* cleanup of the (xslt) code in resources/default/transform to make local references work
* added build script (gen_sissvoc3_config.py) - allows users to generate a sissvoc elda configuration based on properties file and sissvoc-v3-template. See README in the build dir.

## FAQ

Q. How do I get a package of sissvoc? 
A. Refer to https://github.com/CSIRO-enviro-informatics/sissvoc-package

## Build

Pre-requisites:
* Python 2
* Maven
* JDK 8

### 1. Setup elda
```
$ wget https://github.com/epimorphics/elda/archive/elda-2.0.0.tar.gz -O elda.tar.gz
$ tar -xvf elda.tar.gz
$ mv elda-elda-2.0.0 elda
$ cd elda
$ mvn clean package
$ cd ..
```

### 2. Edit the default SISSVoc config

If you would like to customise the default SISSVoc endpoints to your
triple store where your SKOS vocabularies are chosen, the SISSVoc title,
contact, or API name, edit `build/config.properties`.

The build script will generate the sissvoc config and deploy automatically.

### 3. Run sissvoc build scripts
```
$ ./scripts/build.sh
```
This will output the `sissvoc.war` file.

At this point you can deploy this to any Jetty or Apache Tomcat server.

### 4. Deploy using docker-compose

Pre-requisite:
* docker
* docker-compose

If you would like to use docker-compose, you can easily deploy SISSvoc.
```
$ docker-compose up -d
```

You can access your SISSVoc service at: 
* http://localhost:8080/sissvoc/index.html (landing page)
* http://localhost:8080/sissvoc/default/concept (concept API page)
