all:
	gpp -x rst-api-spec.yaml.in > rst-api-spec.yaml
	gpp -x -DINTERNAL rst-api-spec.yaml.in > rst-api-spec-internal.yaml
