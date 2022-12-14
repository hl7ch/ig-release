# Publish an implementation guide ch-xyz with a version (eg 0.1.0)

Background info see [Process for Publishing a FHIR Implementation Guide (for non-HL7 IGs)](https://confluence.hl7.org/pages/viewpage.action?pageId=104580055).


## Repo ch-xyz (implementation guide)
1. Add or update the file **package-list.json** in IG root folder (https://confluence.hl7.org/display/FHIR/FHIR+IG+PackageList+doco).
* `"current": true` if this version should be listed in the current versions summary at the top of the history page. True for the **CI-Build**, and the **version currently posted** to the canonical URL
* CI-Build (first entry): `"version" : "current"`
* The **status** of the publication
* Note the spelling of **fhirversion** (lower case 'v')
* Make sure there is a **category**
* **path**: canonical needs to include the version number

2. Update the ig-file **ch.fhir.ig.[ch-xyz].xml**7**sushi-config.yaml**.   
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
   After the publication change the value back to: `<value value="CI Build"/>`

3. Verify that the current version of the implementation guide is working in the CI build, check http://build.fhir.org/ig/\[githubrepo\]/\[ch-xyz\]/index.html.

4. Set a [tag in GitHub](https://git-scm.com/book/en/v2/Git-Basics-Tagging) and [create a release](https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository#creating-a-release)
```
git tag -a v0.1.0 -m "published version 0.1.0 on yyyy-mm-dd"
```
```
git push origin v0.1.0
```

## Repo ig-release

5. Download the patched version of the [IG Publisher](https://github.com/HL7/fhir-ig-publisher/releases) on a fresh clone with the publisher flag:
```
wget https://github.com/hl7ch/ig-release/releases/download/v1.2.2-patch/publisher.jar -o publisher.jar
```

6. Adjust in publish.ini the path to the ig

```
url=http://fhir.ch/ig/[ch-xyz]
```

7. Run the IG Publisher assuming that your IG is on the same directory level as this project (e.g. replace [ch-xyz] with ch-core or use the corresponding .cmd or .sh)
```
java -Xms3550m -Xmx3550m -jar publisher.jar -go-publish -source $PWD/../[ch-xyz] -destination $PWD/www -registry ig-registry/fhir-ig-list.json -history ig-history
```

8.  For every IG publication:
```
gsutil rsync -r www/[ch-xyz]/[version] gs://fhir-ch-www/ig/[ch-xyz]
gsutil rsync -r www/[ch-xyz]/[version] gs://fhir-ch-www/ig/[ch-xyz]/[version]
```
Update history.html manually: add `"current":true` for published version (and ci build if it is not already set)
```
gsutil cp www/[ch-xyz]/history.html gs://fhir-ch-www/ig/[ch-xyz]
```

9. Check the outputs, it might take a while due to caching issues:
* http://fhir.ch/ig/[ch-xyz]/index.html
* http://fhir.ch/ig/[ch-xyz]/[version]/index.html

10. Update the package registry
* To be able to specify the IG's package for [validation](https://confluence.hl7.org/display/FHIR/Using+the+FHIR+Validator#UsingtheFHIRValidator-Validatingagainstanimplementationguide), the IG package must be added to the [FHIR package registry](https://registry.fhir.org/). To do this update the file **ig-release\www\package-feed.xml** ([validate your feed](https://validator.w3.org/feed/)), see also [here](https://registry.fhir.org/submit). You can take the entry from www\publication-feed.xml and adapt it according to the existing ones, please be sure to add the package version to it.

```
gsutil cp www/package-feed.xml gs://fhir-ch-www/
```

* Check: https://www.fhir.ch/package-feed.xml 

## Repo k8s-fhir.ch
11. Update fhir.ch (if it is the first publication)
* If the published IG is not yet linked on [fhir.ch](http://fhir.ch/), add the requested links in the file **k8s-fhir.ch\fhir-ch\index.html**.
