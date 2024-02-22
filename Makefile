all: diagrams spec

tmpdir:
	@mkdir -p tmp

diagrams: tmpdir
	@echo Generating SVG diagrams...
	@mmdc -i etc/test-object-state-machine.mmd -o etc/test-object-state-machine.svg
	@mmdc -i etc/workflow.mmd -o etc/workflow.svg

spec: tmpdir
	@echo Generating YAML files...
	@gpp -x -DVIEW=EXTERNAL rst-api-spec.yaml.in > tmp/rst-api-spec.yaml
	@gpp -x -DVIEW=INTERNAL rst-api-spec.yaml.in > tmp/rst-api-spec-internal.yaml
	@echo Generating JSON files...
	@yq -o=json eval tmp/rst-api-spec.yaml > tmp/rst-api-spec.json
	@yq -o=json eval tmp/rst-api-spec-internal.yaml > tmp/rst-api-spec-internal.json

lint:
	@openapi-generator validate -i tmp/rst-api-spec-internal.yaml

pages:
	@echo Generating pages...
	@bin/build-pages.sh
