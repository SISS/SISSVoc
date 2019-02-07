#!/bin/bash
## This script assumes that elda and sissvoc releases have been downloaded and unpacked as per the package-sissvoc-vanilla.sh script.
## This script allows users to modify/add/configure files to the elda/sissvoc releases and package into sissvoc.war
set -x #echo on
cd build
#build default and pizza sissvoc configs
python gen_sissvoc3_config.py --config=config.properties default_sissvoc.ttl
cd ..
#create sissvoc package and output war file for application server
mkdir sissvoc-pkg
cd sissvoc-pkg
cp -rf ../elda/elda-common/target/elda-common/* .
cp -rf ../elda/elda-assets/target/elda-assets lda-assets
cp -rf ../resources/ default-landing/ .
cp ../build/default_sissvoc.ttl resources/default/config
sed -i "s/<param-value>\/etc\/elda\/conf.d\/{APP}\/\*.ttl<\/param-value>/<param-value>resources\/default\/config\/\*.ttl<\/param-value>/g" WEB-INF/web.xml
jar -cvf sissvoc.war *
mv sissvoc.war ..
