# Publish an implementation guide ch-xyz with a version (eg 0.1.0)

Background info see [Process for Publishing a FHIR Implementation Guide (for non-HL7 IGs)](https://confluence.hl7.org/pages/viewpage.action?pageId=104580055).

1. Use gihub pages as a backup for the published ig's hl7ch.github.ch, we use this as a subfolder in ig-release 
2. Publish the guide from the local system to the github pages folder
3. Sync github pages folder to google drive (which fhir.ch servs up the pages from including rediredcts)
4. Update github apges

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
     <value value="ballot"/>
   </parameter>
   ```
   After the publication change the value back to: `<value value="CI-Build"/>`

or in sushi-config.yaml
date: 2023-06-29
version: 4.0.0-ballot
releaselabel: ballot
license: CC0-1.0
verify correct terminology dependency
dependencies:
  hl7.terminology: 5.1.0

add STU note in index.md along the lines into the stu-note:

```
This implementation guide is under STU ballot by [HL7 Switzerland](https://www.hl7.ch/) until September 30th, 2023 midnight.
Please add your feedback via the ‘Propose a change’-link in the footer on the page where you have comments. 
```

2. Create/update the file **publication-request.json** in the IG root folder, see https://confluence.hl7.org/display/FHIR/IG+Publication+Request+Documentation.   
   **Workaround:** At the moment it works only with `"milestone" : false`.

```json
{
  "package-id" : "ch.fhir.ig.ch-epr-term",
  "version" : "2.0.9",
  "path" : "http://fhir.ch/ig/ch-epr-term/2.0.9",
  "mode" : "milestone",
  "status" : "trial-use",
  "sequence" : "STU",
  "desc" : "Version 202306.1-stable, see https://ehealthsuisse.art-decor.org/ch-epr-html-20230608T154548/project.html for changelog",
  "first": false
}
```

verify that package-list is updated with the latest published version (might be that the latest version is in www/[ch-xyz])
http://fhir.ch/ig/[ch-xyz]/package-list.json

3. Build your IG local (for some checks).

4. Verify also that the current version of the implementation guide is working in the CI build, check http://build.fhir.org/ig/\[githubrepo\]/\[ch-xyz\]/index.html.

5. Set a [tag in GitHub](https://git-scm.com/book/en/v2/Git-Basics-Tagging) and [create a release](https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository#creating-a-release)
```
git tag -a v0.1.0 -m "published version 0.1.0 on yyyy-mm-dd"
```
git tag -a v2.0.0-ballot -m "published version 2.0.0-ballot on 2023-06-30"


```
git push origin v3.2.0-ballot
```

## Repo ig-release

6. Sync up github pages

```
cd hl7ch.github.io
git pull
```

if for the first time:

```
git clone https://github.com/hl7ch/hl7ch.github.io.git
```

7. Download the latest version of the [IG Publisher](https://github.com/HL7/fhir-ig-publisher/releases) on a fresh clone with the publisher flag:
```
wget https://github.com/HL7/fhir-ig-publisher/releases/latest/download/publisher.jar -o publisher.jar
```

8. Run the IG Publisher assuming that your IG is on the same directory level as this project 

./publish.sh [ch-xyz]


10.  For every IG publication:

```
./fhir-ch-www.sh ch-vacd 4.0.0-ballot
```

11. Check the outputs, it might take a while due to caching issues:
* http://fhir.ch/ig/[ch-xyz]/index.html
* http://fhir.ch/ig/[ch-xyz]/[version]/index.html
* http://fhir.ch/ig/[ch-xyz]/history.html   (needs to be copied manually sometimes?)


12. Update github packages

```
cd hl7ch.github.io 
git add .
git commit -m 'ch-xyz version'
git push   
```

## Repo k8s-fhir.ch
13. Update fhir.ch (if it is the first publication)
* If the published IG is not yet linked on [fhir.ch](http://fhir.ch/), add the requested links in the file **k8s-fhir.ch\fhir-ch\index.html**.


### How to move tags ...

Delete the tag on any remote before you push

git push origin :refs/tags/<tagname>
Replace the tag to reference the most recent commit

git tag -fa <tagname>
Push the tag to the remote origin

git push origin --tags