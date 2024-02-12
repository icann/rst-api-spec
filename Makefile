all: diagrams spec

tmpdir:
	@mkdir -p tmp

diagrams: tmpdir
	@echo Generating SVG diagrams...
	@mmdc -i etc/test-object-state-machine.mmd -o tmp/test-object-state-machine.svg
	@mmdc -i etc/workflow.mmd -o tmp/workflow.svg

spec: tmpdir
	@echo Generating YAML files...
	@gpp -x -DVIEW=EXTERNAL rst-api-spec.yaml.in > tmp/rst-api-spec.yaml
	@gpp -x -DVIEW=INTERNAL rst-api-spec.yaml.in > tmp/rst-api-spec-internal.yaml

pages:
	@echo Generating pages...
	@bin/build-pages.sh
