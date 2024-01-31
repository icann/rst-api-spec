all: diagrams spec

diagrams:
	mmdc -i etc/test-object-state-machine.mmd -o etc/test-object-state-machine.svg
	mmdc -i etc/workflow.mmd -o etc/workflow.svg

spec:
	gpp -x -DVIEW=EXTERNAL rst-api-spec.yaml.in > rst-api-spec.yaml
	gpp -x -DVIEW=INTERNAL rst-api-spec.yaml.in > rst-api-spec-internal.yaml
