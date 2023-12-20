# Publish an implementation guide ch-xyz with a version

Background info see [Process for Publishing a FHIR Implementation Guide (for non-HL7 IGs)](https://confluence.hl7.org/pages/viewpage.action?pageId=104580055).

1. Use github pages as a backup for the published IG's hl7ch.github.ch, we use this as a subfolder in ig-release 
2. Publish the guide from the local system to the github pages folder
3. Sync github pages folder to google drive (which fhir.ch servs up the pages from including redirects)
4. Update github pages

## Repo ch-xyz (implementation guide)

Navigate to the IG repo:

```
cd ch-xyz
```

1. Update/check the IG file **ch.fhir.ig.[ch-xyz].xml** or **sushi-config.yaml**.   
* date: 2023-12-19
* version: 4.0.0 (or 4.0.0-ballot)
   * after the publication change the value to {next-proposed-version}-ci-build
* releaselabel: trial-use (ci-build | draft | qa-preview | ballot | trial-use | release | update | normative+trial-use)   
   * after the publication change the value to ci-build
* dependencies -> verify the version values, incl. the correct terminology dependency (hl7.terminology: 5.4.0) 
* license: CC0-1.0

2. Update the STU note box in index.md according to the type of publication (e.g. ballot):   

```
This implementation guide is under STU ballot by [HL7 Switzerland](https://www.hl7.ch/) until September 30th, 2023 midnight.
Please add your feedback via the ‘Propose a change’-link in the footer on the page where you have comments. 
```

3. Create/update the file **publication-request.json** in the IG root folder, see https://confluence.hl7.org/display/FHIR/IG+Publication+Request+Documentation.   
   * after the publication rename the file to publication-request.json.bak

```json
{
  "package-id" : "ch.fhir.ig.ch-core",
  "version" : "4.0.0",
  "path" : "http://fhir.ch/ig/ch-core/4.0.0",
  "mode" : "milestone",
  "status" : "trial-use",
  "sequence" : "STU 4",
  "desc" : "HL7 Switzerland STU 4",
  "changes" : "changelog.html",
  "first": false
}
```

4. Build your IG local (for some checks).

5. Verify also that the current version of the implementation guide is working in the CI build:   
http://build.fhir.org/ig/\[githubrepo\]/\[ch-xyz\]/index.html.

6. [Set a tag](https://git-scm.com/book/en/v2/Git-Basics-Tagging) 
```
git tag -a v4.0.0 -m "published version 4.0.0 on 2023-12-19"   
git push origin v4.0.0
```

and [create a release](https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository#creating-a-release) in GitHub.

## Repo ig-release

Navigate to the ig-release repo:
```
cd ..
cd ig-release
```

7. Sync up github pages

```
cd hl7ch.github.io
git pull
```

if for the first time:

```
git clone https://github.com/hl7ch/hl7ch.github.io.git
```

8. Download the latest version of the [IG Publisher](https://github.com/HL7/fhir-ig-publisher/releases) on a fresh clone with the publisher flag (in the ig-release folder):

```
cd ..
wget https://github.com/HL7/fhir-ig-publisher/releases/latest/download/publisher.jar -o publisher.jar
```

9. Run the IG Publisher assuming that your IG is on the same directory level as this project: 

```
./publish.sh [ch-xyz]
```

Check the local output (incl. automatically filled out publication box) in hl7ch.github.io/ig/ch-xyz/4.0.0

10. Verify that package-list.json is updated:   
ig-release/hl7ch.github.io/ig/\[ch-xyz\]/package-list.json

If not, please do following updates:   
* ig-release/hl7ch.github.io/ig/\[ch-xyz\]/package-list.json -> add missing entry
* ig-release/hl7ch.github.io/ig/\[ch-xyz\]/history.html -> add the updated content from package-list.json (https://jsontostring.com/convert-json-to-one-line/)

_It didn't work automatically for following IG's during the last publication on 2023-12-20:_
* _ch-allergyintolerance_
* _ch-vacd_

11.  For every IG publication:

```
./fhir-ch-www.sh ch-xyz 4.0.0
```

12. Check the outputs, it might take a while due to caching issues:
* http://fhir.ch/ig/[ch-xyz]/index.html
* http://fhir.ch/ig/[ch-xyz]/[version]/index.html
* http://fhir.ch/ig/[ch-xyz]/history.html (longer caching... needs to be copied manually sometimes...?)


13. Update github packages

```
cd hl7ch.github.io 
git add .
git commit -m 'ch-xyz version'
git push   
```

and update ig-release

```
cd ..
git add .
git commit -m 'update after publication ch-xyz version'
git push   
```

14. Check if the new entry is added in the package feed:   
https://fhir.ch/package-feed.xml

## Repo k8s-fhir.ch
15. Update fhir.ch (if it is the first publication)
* If the published IG is not yet linked on [fhir.ch](http://fhir.ch/), add the requested links in the file **k8s-fhir.ch\fhir-ch\index.html**.


### How to move tags ...

Delete the tag on any remote before you push

git push origin :refs/tags/<tagname>   
Replace the tag to reference the most recent commit

git tag -fa <tagname>   
Push the tag to the remote origin

git push origin --tags
