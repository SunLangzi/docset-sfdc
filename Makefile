.PHONY: all clean-index package-lightning

default: all

all: clean-index package-lightning

run-lightning: clean-index
	dep ensure
	go run ./SFDashC/*.go lightning

package-lightning: run-lightning
	$(eval name = Lightning)
	$(eval package = Salesforce $(name).docset)
	$(eval version = $(shell cat ./build/lightning-version.txt))
	cat ./SFDashC/docset-lightning.json | sed s/VERSION/$(version)/ > ./build/docset-lightning.json
	mkdir -p "$(package)/Contents/Resources/Documents"
	cp -r ./build/atlas.en-us.lightning.meta "$(package)/Contents/Resources/Documents/"
	cp -r ./SFDashC/resource "$(package)/Contents/Resources/Documents"
	cp ./build/*.html "$(package)/Contents/Resources/Documents/"
	cp ./build/*.css "$(package)/Contents/Resources/Documents/"
	cp ./SFDashC/Info-$(name).plist "$(package)/Contents/Info.plist"
	cp ./SFDashC/icon.png "$(package)/"
	cp ./SFDashC/icon@2x.png "$(package)/"
	cp ./build/docSet.dsidx "$(package)/Contents/Resources/"
	@echo "Docset generated!"

archive:
	find *.docset -depth 0 | xargs -I '{}' sh -c 'tar --exclude=".DS_Store" -czf "$$(echo {} | sed -e "s/\.[^.]*$$//" -e "s/ /_/").tgz" "{}"'
	@echo "Archives created!"

clean-index:
	rm -f ./build/docSet.dsidx

clean: clean-index
	rm -fr ./build
	rm -fr *.docset
	rm -f *.tgz
