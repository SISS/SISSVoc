# Spatial Information Services Stack Vocabulary Service (SISSVoc)

[![Build Status](https://travis-ci.org/SISS/SISSVoc.svg?branch=master)](https://travis-ci.org/SISS/SISSVoc)

Updated: 7 Feb 2019

Contact: Jonathan Yu (jonathan.yu [ at ] csiro.au)


## About

SISSVoc is a Linked Data API for accessing published vocabularies. SISSVoc provides a RESTful interface via a set of URI patterns that are aligned with SKOS. These provide a standard web interface for any vocabulary which uses SKOS classes and properties.

SISSVoc provides web pages for human-readable views, and machine-readable resources for client applications (in RDF, JSON, and XML). SISSVoc is implemented using a Linked Data API façade over a SPARQL endpoint. This approach streamlines the configuration of content negotiation, styling, query construction and dispatching.

This repo features resources required to build SISSvoc. The [releases section](https://github.com/SISS/SISSVoc/releases) now provides a built .war file distribution which wraps the configuration assets as part of an automated build on release. Download the latest version there.

A docker image is also available for deployment - see https://hub.docker.com/r/csiroenvinf/sissvoc for more details on using docker to deploy SISSvoc.

### What's new?

* automated build via travis
* docker-compose deployment option
* build scripts included
* cleanup of the (xslt) code in resources/default/transform to make local references work
* added build script (gen_sissvoc3_config.py) - allows users to generate a sissvoc elda configuration based on properties file and sissvoc-v3-template. See README in the build dir.
* SISSvoc docker image

## Quickstart


### Using docker
Pre-requisite: Docker CE 1.7+

```
$ docker run -p "8080:8080" csiroenvinf/sissvoc:latest
```

You can access your SISSVoc service at: 
* http://localhost:8080/sissvoc/index.html (landing page)
* http://localhost:8080/sissvoc/default/concept (concept API page)

### Tomcat

Drop the latest sissvoc.war file in the [releases section](https://github.com/SISS/SISSVoc/releases) into the /webapps dir of your tomcat service. 

You can access your SISSVoc service at: 
* /sissvoc/index.html (landing page)
* /sissvoc/default/concept (concept API page)


## Custom Build

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

If you would like to use docker-compose, you can easily deploy your custom built sissvoc.war...
```
$ docker-compose -f docker-compose.localsissvoc.yml up -d
```

You can access your SISSVoc service at: 
* http://localhost:8080/sissvoc/index.html (landing page)
* http://localhost:8080/sissvoc/default/concept (concept API page)

## Creating a custom config

If you want to create your own custom SISSvoc config file, the main SISSVoc repo has a build directory with some scripts to help create custom SISSvoc config files. See https://github.com/SISS/SISSVoc/tree/master/build

Create a my-config.properties file based on `config.properties.

Run the following:
```
$ python2 gen_sissvoc3_config.py --config=my-config.properties my-sissvoc-config.ttl
```

### Using docker 
You can then map in my-sissvoc-config.ttl to the sissvoc container and it will automagically map in the endpoints you specified.

```
$ docker run -v  "my-sissvoc-config.ttl:/usr/local/tomcat/webapps/sissvoc/resources/default/config/default_sissvoc.ttl" csiroenvinf/sissvoc:latest
```

### Tomcat

You can copy my-sissvoc-config.ttl and overwrite the /webapps/sissvoc/resources/default/config/default_sissvoc.ttl file in your Tomcat configuration. Restart tomcat and you should see the result.
