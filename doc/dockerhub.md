SISSVoc is a Linked Data API for accessing published vocabularies. SISSVoc provides a RESTful interface via a set of URI patterns that are aligned with SKOS. These provide a standard web interface for any vocabulary which uses SKOS classes and properties. SISSVoc provides web pages for human-readable views, and machine-readable resources for client applications (in RDF, JSON, and XML). SISSVoc is implemented using a Linked Data API façade over a SPARQL endpoint. This approach streamlines the configuration of content negotiation, styling, query construction and dispatching.

This docker image build of SISSvoc uses the Tomcat base docker image. SISSvoc uses a vanilla build of ELDA and a mapping of a default configuration into that environment. This docker image simplifies the deploy process into a few steps.

This docker image is maintained by the CSIRO Environmental Informatics group.

Supported tags and respective Dockerfile links
latest and alpine
Running
$ docker run -p "8080:8080" csiroenvinf/sissvoc:latest
If you prefer an alpine linux based docker image, use alpine

$ docker run -p "8080:8080" csiroenvinf/sissvoc:alpine
You can access your sissvoc site at http://localhost:8080/sissvoc/index.html. http://localhost:8080/sissvoc/meta/api will list available SISSvoc configurations and instances.

In a vanilla sissvoc container, the default sissvoc service should be running against the Pizza SKOS example Sparql service at http://www.sissvoc.info/services/pizza-skos/sparql. Access the concept endpoint here:

http://localhost:8080/sissvoc/default/concept
Mapping your custom SISSvoc config file
The easiest way to configure the docker sissvoc instance is to overwrite the default SISSVoc config file default_sissvoc.ttl with your own. If you have a custom SISSvoc config file, you can do that like so:

$ docker run -p "8080:8080" -v  "$(pwd)/example-config.ttl:/usr/local/tomcat/webapps/sissvoc/resources/default/config/default_sissvoc.ttl" csiroenvinf/sissvoc:latest
Creating your custom SISSvoc config file
If you want to create your own custom SISSvoc config file, the main SISSVoc repo has a build directory with some scripts to help create custom SISSvoc config files. See https://github.com/SISS/SISSVoc/tree/master/build

Create a my-config.properties file based on `config.properties.

Run the following:

$ python2 gen_sissvoc3_config.py --config=my-config.properties my-sissvoc-config.ttl
You can then map in my-sissvoc-config.ttl to the sissvoc container and it will automagically map in the endpoints you specified.

Using docker-compose
If you prefer to deploy using docker-compose, an example docker-compose.yml file might be written like this:

version: "3"
services:
  sissvoc:
    image: csiroenvinf/sissvoc:latest
    ports:
      - "8080:8080"
    volumes:
      - "./example/my-sissvoc-config.ttl:/usr/local/tomcat/webapps/sissvoc/resources/default/config/default_sissvoc.ttl"
You can then create the containers like so:

$ docker-compose up -d

