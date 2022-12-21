# Publish an implementation guide ch-xyz with a version (eg 0.1.0)

Background info see [Process for Publishing a FHIR Implementation Guide (for non-HL7 IGs)](https://confluence.hl7.org/pages/viewpage.action?pageId=104580055).


## Repo ch-xyz (implementation guide)

1. Update the IG file **ch.fhir.ig.[ch-xyz].xml** or **sushi-config.yaml**.   
Note: The title and the parameter release label are displayed at the top of the published website.
* `<version value="0.1.0"/>`
   After the publication change the value to: `<version value="{next-proposed-version}-cibuild"/>`
* `<date value="2022-12-20"/>`
* `<title value="IG XYZ (R4)"/>`
* `<dependsOn>` -> check the version value
   ``` xml
   <parameter>
     <code value="releaselabel"/>
     <value value="STU1 Ballot"/>
   </parameter>
   ```
   After the publication change the value back to: `<value value="CI-Build"/>`


2. Create/update the file **publication-request.json** in the IG root folder, see https://confluence.hl7.org/display/FHIR/IG+Publication+Request+Documentation.   
   **Workaround:** At the moment it works only with `"milestone" : false`.


3. Create/update the file **publish.ini** in the IG root folder, like this:
```
[website]
style=fhir.layout
server=apache
url=http://fhir.ch/ig/[ch-xyz]
org=HL7 Switzerland
no-registry=1
owner = hl7ch

layout=ch.fhir.ig.[ch-xyz]|http://fhir.ch/ig/[ch-xyz]

[feeds]
package=package-feed.xml
publication=publication-feed.xml
```

4. Build your IG local (for some checks).

5. Verify also that the current version of the implementation guide is working in the CI build, check http://build.fhir.org/ig/\[githubrepo\]/\[ch-xyz\]/index.html.

6. Set a [tag in GitHub](https://git-scm.com/book/en/v2/Git-Basics-Tagging) and [create a release](https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository#creating-a-release)
```
git tag -a v0.1.0 -m "published version 0.1.0 on yyyy-mm-dd"
```
```
git push origin v0.1.0
```

## Repo ig-release

7. Download the latest version of the [IG Publisher](https://github.com/HL7/fhir-ig-publisher/releases) on a fresh clone with the publisher flag:
```
wget https://github.com/HL7/fhir-ig-publisher/releases/latest/download/publisher.jar -o publisher.jar
```
**Workaround:** Does not work at the moment, had to adapt the IG publisher.

6. Copy the file **publication-request.json** from the repo ch-xyz to the www folder in this repo.
7. Copy the file **publish.ini** from the repo ch-xyz to the www/ch-xyz in this repo.

8. **Workaround:** To get a correct publication box in the build process you have to remove `"current":true` from the latest published version in the package-list.json.

9. Run the IG Publisher assuming that your IG is on the same directory level as this project -> adapt and use one of the existing .cmd or .sh.
   **Note:** Create a folder **temp** and set it as parameter.

10.  For every IG publication:
```
gsutil rsync -r www/[ch-xyz]/[version] gs://fhir-ch-www/ig/[ch-xyz]
gsutil rsync -r www/[ch-xyz]/[version] gs://fhir-ch-www/ig/[ch-xyz]/[version]
```
**Workaround:**   
Add `"current":true` for published version in package-list.json.   
Update history.html manually: update the included package-list.json   .
```
gsutil cp www/[ch-xyz]/history.html gs://fhir-ch-www/ig/[ch-xyz]
```

11. Check the outputs, it might take a while due to caching issues:
* http://fhir.ch/ig/[ch-xyz]/index.html
* http://fhir.ch/ig/[ch-xyz]/[version]/index.html
* http://fhir.ch/ig/[ch-xyz]/history.html

12. Update the package registry
* To be able to specify the IG's package for [validation](https://confluence.hl7.org/display/FHIR/Using+the+FHIR+Validator#UsingtheFHIRValidator-Validatingagainstanimplementationguide), the IG package must be added to the [FHIR package registry](https://registry.fhir.org/). To do this update the file **ig-release\www\package-feed.xml** ([validate your feed](https://validator.w3.org/feed/)), see also [here](https://registry.fhir.org/submit). You can take the entry from www\publication-feed.xml and adapt it according to the existing ones, please be sure to add the package version to it.

```
gsutil cp www/package-feed.xml gs://fhir-ch-www/
```

* Check: https://www.fhir.ch/package-feed.xml 

## Repo k8s-fhir.ch
13. Update fhir.ch (if it is the first publication)
* If the published IG is not yet linked on [fhir.ch](http://fhir.ch/), add the requested links in the file **k8s-fhir.ch\fhir-ch\index.html**.
