CF=node_modules/.bin/commonform
plaintemplate=node_modules/plaintemplate
FORMS=agreement-hourly-maintenance.generated agreement-monthly-maintenance.generated
TARGETS=$(FORMS:.generated=.docx)

all: $(TARGETS)

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

.PHONY: lint critique clean

lint: $(FORMS) $(CF)
	for form in $(FORMS); do \
		echo ; \
		echo $$form; \
		$(CF) lint < $$form; \
	done; \

critique: $(FORMS) $(CF)
	for form in $(FORMS); do \
		echo ; \
		echo $$form ; \
		$(CF) critique < $$form; \
	done

clean:
	rm -rf $(TARGETS)
