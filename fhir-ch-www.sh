gsutil -m cp -r ./hl7ch.github.io/ig/$1/$2 gs://fhir-ch-www/ig/$1/$2
gsutil -m cp ./hl7ch.github.io/ig/$1/* gs://fhir-ch-www/ig/$1
gsutil -m cp -r ./hl7ch.github.io/ig/$1/assets/* gs://fhir-ch-www/ig/$1/assets/
gsutil -m cp -r ./hl7ch.github.io/ig/$1/assets-hist/* gs://fhir-ch-www/ig/$1/assets-hist/
gsutil -m cp ./hl7ch.github.io/*.json gs://fhir-ch-www/
gsutil -m cp ./hl7ch.github.io/*.xml gs://fhir-ch-www/