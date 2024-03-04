all: diagrams spec

tmpdir:
	@mkdir -p tmp

diagrams: tmpdir
	@echo Generating SVG diagrams...
	@mmdc -i etc/test-object-state-machine.mmd -o etc/test-object-state-machine.svg
	@mmdc -i etc/workflow.mmd -o etc/workflow.svg

includes: tmpdir
	@echo Generating YAML fragments...
	@bin/generate-test-plan-mnemonics.pl > tmp/test-plan-mnemonics.yaml
	@bin/generate-input-parameter-schema.pl > tmp/input-parameters.yaml
	@bin/generate-test-cases.pl > tmp/test-cases.yaml
	@bin/generate-error-codes.pl > tmp/error-codes.yaml
	
spec: tmpdir includes
	@echo Generating YAML file...
	@gpp -x rst-api-spec.yaml.in > tmp/rst-api-spec.yaml

	@echo Generating JSON file...
	@yq -o=json eval tmp/rst-api-spec.yaml > tmp/rst-api-spec.json

lint:
	@openapi-generator validate -i tmp/rst-api-spec.yaml

pages:
	@echo Generating pages...
	@bin/build-pages.sh
