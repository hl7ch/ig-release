## Publish an implementation guide ch-xyz with a version (eg 0.1.0)

Background info see [HL7 Process for Publishing a FHIR IG](https://confluence.hl7.org/display/FHIR/HL7+Process+for+Publishing+a+FHIR+IG).


1. Add or update the file **package-list.json** in folder www (https://confluence.hl7.org/display/FHIR/FHIR+IG+PackageList+doco).
* `"current": true` if this version should be listed in the current versions summary at the top of the history page. True for the **CI-Build**, and the **version currently posted** to the canonical URL
* CI-Build (first entry): `"version" : "current"`
* The **status** of the publication
* Note the spelling of **fhirversion** (lower case 'v')
* Make sure there is a **category**
* canonical needs to include the version number

2. Update the ig-file **ch.fhir.ig.[igxyz].xml** in folder input.   
Note: The title and the parameter release label are displayed at the top of the published website.
* `<version value="0.1.0"/>`
* `<date value="2020-08-24"/>`
* `<title value="IG XYZ (R4)"/>`
* `<dependsOn>` -> check the version value
*  ```
   <parameter>
     <code value="releaselabel"/>
     <value value="STU Ballot"/>
   </parameter>
   ```
   After the publication change the value back to: `<value value="CI build"/>`

3. Verify that the current version of the implementation guide is working in the CI build, check http://build.fhir.org/ig/\[githubrepo\]/\[igxyz\]/index.html.

4. Download the new version of the [IG Publisher](https://github.com/HL7/fhir-ig-publisher/releases) on a fresh clone with the publisher flag:
```
wget https://github.com/HL7/fhir-ig-publisher/releases/latest/download/publisher.jar -O publisher.jar
```

5. Run the IG Publisher assuming that your ig is on the same directory level as this project (e.g. for ch-core)
```
java -Xms3550m -Xmx3550m -jar publisher.jar -go-publish -source $PWD/../ch-core -destination $PWD/www -registry ig-registry/fhir-ig-list.json -history ig-history
```

6.  For every IG publication:
```
gsutil rsync -r www/[igxyz] gs://fhir-ch-www/ig/[igxyz]
```

7. Check the outputs, it might take a while due to caching issues:
* http://fhir.ch/ig/[igxyz]/index.html
* http://fhir.ch/ig/[igxyz]/[version]/index.html

8. Set a [tag in GitHub](https://git-scm.com/book/en/v2/Git-Basics-Tagging) and [create a release](https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository#creating-a-release)
```
git tag -a v0.1.0 -m "published version 0.1.0 on yyyy-mm-dd"
```
```
git push origin v0.1.0
```

9. Update fhir.ch and package registry
* If the published IG is not yet linked on [fhir.ch](http://fhir.ch/), add the requested links in the file fhir-ch\index.html.
* To be able to specify the IG's package for [validation](https://confluence.hl7.org/display/FHIR/Using+the+FHIR+Validator#UsingtheFHIRValidator-Validatingagainstanimplementationguide), the IG package must be added to the [FHIR package registry](https://registry.fhir.org/). To do this update the file fhir-ch\package-feed.xml ([validation feed](https://validator.w3.org/feed/)), see also [here](https://registry.fhir.org/submit). You can take the
entry from www\package-feed.xml, please be sure to add the package version to it.