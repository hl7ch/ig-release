java -jar -Dfile.encoding=UTF-8 -Xms3550m -Xmx3550m publisher.jar -go-publish -source $PWD/../$1 -web $PWD/hl7ch.github.io -registry ig-registry/fhir-ig-list.json -history ig-history -templates hl7ch.github.io/templates -temp $PWD/buildtmp