CF = node_modules/.bin/commonform
PTEMPLATE = node_modules/plaintemplate
FORMS = agreement-hourly-maintenance.generated agreement-monthly-maintenance.generated
TARGETS = $(FORMS:.generated=.docx)
PDFS = $(FORMS:.generated=.pdf)

all: $(TARGETS)

pdf: $(PDFS)

%.pdf: %.docx
	doc2pdf $<

%.docx: %.generated %.blanks signatures.json $(CF)
	$(CF) render \
	--format docx \
	--blanks $*.blanks \
	--signatures signatures.json \
	--title "Agreement for Design Services" \
	--number outline \
	< $*.generated > $*.docx

agreement-hourly-maintenance.generated: agreement.cform generate.js
	node generate.js hourly < agreement.cform > $@

agreement-monthly-maintenance.generated: agreement.cform generate.js
	node generate.js monthly < agreement.cform > $@

%.blanks: blanks.js %.directions blanks.json
	node $^ > $@

%.directions: %.generated $(CF)
	$(CF) directions < $< > $@

$(CF) $(PTEMPLATE):
	npm i

generate.js: $(PTEMPLATE)

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
	rm -rf $(FORMS) $(TARGETS) $(PDFS)
