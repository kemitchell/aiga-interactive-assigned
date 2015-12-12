CF=node_modules/.bin/commonform

all: agreement.docx

$(CF):
	npm i commonform-cli

%.docx: %.cform %.options %.signatures.json $(CF)
	$(CF) render \
		--format docx \
		--signatures $*.signatures.json \
		$(shell cat $*.options) \
		< $*.cform > $*.docx
