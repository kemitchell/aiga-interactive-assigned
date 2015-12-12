CF=node_modules/.bin/commonform
plaintemplate=node_modules/plaintemplate

all: agreement-hourly-maintenance.docx agreement-monthly-maintenance.docx

generate.js: $(plaintemplate)

agreement-hourly-maintenance.generated: agreement.cform generate.js
	node generate.js hourly < agreement.cform > $@

agreement-monthly-maintenance.generated: agreement.cform generate.js
	node generate.js monthly < agreement.cform > $@

$(CF) $(plaintemplate):
	npm i

%.directions: %.generated $(CF)
	$(CF) directions < $< > $@

%.blanks: blanks.js %.directions blanks.json
	node $^ > $@

%.docx: %.generated %.blanks options signatures.json $(CF)
	$(CF) render \
		--format docx \
		--blanks $*.blanks \
		--signatures signatures.json \
		$(shell cat options) \
		< $*.generated > $*.docx
