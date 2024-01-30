all: diagrams spec

diagrams:
	mmdc -i etc/test-object-state-machine.mmd -o etc/test-object-state-machine.svg
	mmdc -i etc/workflow.mmd -o etc/workflow.svg

spec:
	gpp -x -DEXTERNAL rst-api-spec.yaml.in > rst-api-spec.yaml
	gpp -x -DINTERNAL rst-api-spec.yaml.in > rst-api-spec-internal.yaml
