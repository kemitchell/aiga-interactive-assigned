CF=node_modules/.bin/commonform
plaintemplate=node_modules/plaintemplate

all: agreement-hourly-maintenance.docx agreement-monthly-maintenance.docx

generate.js: $(plaintemplate)

agreement-hourly-maintenance.cform: agreement.cform generate.js
	node generate.js hourly < agreement.cform > $@

agreement-monthly-maintenance.cform: agreement.cform generate.js
	node generate.js monthly < agreement.cform > $@

$(CF) $(plaintemplate):
	npm i

%.docx: %.cform options signatures.json $(CF)
	$(CF) render \
		--format docx \
		--signatures signatures.json \
		$(shell cat options) \
		< $*.cform > $*.docx
